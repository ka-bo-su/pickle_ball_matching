import Foundation
import PickleBallMatchingCore

@MainActor
final class OperationBoardViewModel: ObservableObject {
    @Published var session: Session
    @Published var newParticipantName = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var canUndo = false
    @Published private(set) var undoCount = 0

    private let generateNextRoundUseCase: GenerateNextRoundUseCase
    private let sessionRepository: (any SessionRepository)?
    private let roundExporter: any RoundExporting
    private let undoHistoryLimit = 10
    private var undoSessions: [Session] = []

    init(
        session: Session? = nil,
        generateNextRoundUseCase: GenerateNextRoundUseCase = GenerateNextRoundUseCase(),
        sessionRepository: (any SessionRepository)? = nil,
        roundExporter: any RoundExporting = CSVRoundExporter()
    ) {
        self.generateNextRoundUseCase = generateNextRoundUseCase
        self.sessionRepository = sessionRepository
        self.roundExporter = roundExporter

        if let session {
            self.session = session
        } else {
            do {
                self.session = try sessionRepository?.loadLatestSession() ?? .defaultSession()
            } catch {
                self.session = .defaultSession()
                errorMessage = "保存済みセッションを読み込めませんでした。新規セッションで開始します。"
            }
        }
    }

    var currentRound: Round? {
        session.currentRound
    }

    var currentRoundCSV: String? {
        guard let currentRound else {
            return nil
        }

        return roundExporter.exportCSV(session: session, round: currentRound)
    }

    var largeBoardDisplayModel: LargeBoardDisplayModel? {
        guard let currentRound else {
            return nil
        }

        let waitingNames = currentRound.waitingParticipants.map(\.displayName)
        return LargeBoardDisplayModel(
            sessionName: session.name,
            roundTitle: "ラウンド\(currentRound.number)",
            announcement: waitingNames.isEmpty ? "待機者はいません" : "待機 \(waitingNames.joined(separator: "、"))",
            courts: currentRound.matches.map { match in
                LargeBoardCourtDisplay(
                    courtNumber: match.courtNumber,
                    teamAPlayerNames: match.teamA.players.map(\.displayName),
                    teamBPlayerNames: match.teamB.players.map(\.displayName)
                )
            },
            waitingPlayerNames: waitingNames
        )
    }

    var canGenerateRound: Bool {
        session.participants.count(where: { $0.status.isAvailableForRound }) >= 4
    }

    var undoButtonTitle: String {
        undoCount > 0 ? "1手戻す（\(undoCount)）" : "1手戻す"
    }

    var undoButtonAccessibilityLabel: String {
        undoCount > 0 ? "直前の入れ替えを1手戻す。戻せる操作は\(undoCount)件です。" : "直前の入れ替えを1手戻す"
    }

    func updateSessionName(_ name: String) {
        session.name = name
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func updateRoundDurationMinutes(_ minutes: Int) {
        session.roundDurationMinutes = max(1, minutes)
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func updateOperationMode(_ mode: OperationMode) {
        session.mode = mode
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func startNewSession() {
        session = .emptyDaySession()
        clearUndoHistory()
        errorMessage = nil
        saveSession()
    }

    func startNewSessionKeepingRoster() {
        var newSession = Session.emptyDaySession()
        newSession.participants = session.participants.map(resetParticipantForNewSession)
        session = newSession
        clearUndoHistory()
        errorMessage = nil
        saveSession()
    }

    func addParticipant() {
        let name = newParticipantName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            return
        }

        session.participants.append(
            Participant(
                displayName: name,
                skillLevel: defaultSkillLevel(for: session.participants.count)
            )
        )
        newParticipantName = ""
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func removeParticipants(at offsets: IndexSet) {
        session.participants.remove(atOffsets: offsets)
        session.updatedAt = Date()
        clearUndoHistory()
        saveSession()
    }

    func updateCourtCount(_ courtCount: Int) {
        session.courtCount = max(1, courtCount)
        session.updatedAt = Date()
        clearUndoHistory()
        saveSession()
    }

    func updateParticipantStatus(participantID: Participant.ID, status: ParticipantStatus) {
        guard let index = session.participants.firstIndex(where: { $0.id == participantID }) else {
            return
        }

        session.participants[index].status = status
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func updateParticipantSkillLevel(participantID: Participant.ID, skillLevel: SkillLevel) {
        guard let index = session.participants.firstIndex(where: { $0.id == participantID }) else {
            return
        }

        session.participants[index].skillLevel = skillLevel
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func updateParticipantDetails(
        participantID: Participant.ID,
        displayName: String,
        gender: Gender,
        ageGroup: AgeGroup,
        memo: String
    ) {
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty,
              let index = session.participants.firstIndex(where: { $0.id == participantID })
        else {
            return
        }

        session.participants[index].displayName = trimmedName
        session.participants[index].gender = gender
        session.participants[index].ageGroup = ageGroup
        session.participants[index].memo = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        session.updatedAt = Date()
        errorMessage = nil
        clearUndoHistory()
        saveSession()
    }

    func generateNextRound() {
        do {
            session = try generateNextRoundUseCase.execute(session: session)
            errorMessage = nil
            clearUndoHistory()
            saveSession()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func replaceCurrentRoundPlayer(playerID: Participant.ID, with waitingParticipantID: Participant.ID) {
        swapCurrentRoundParticipants(firstID: playerID, secondID: waitingParticipantID)
    }

    func swapCandidates(for participantID: Participant.ID) -> [Participant] {
        currentRound?.participantsInRound.filter { $0.id != participantID } ?? []
    }

    func swapCurrentRoundParticipants(firstID: Participant.ID, secondID: Participant.ID) {
        guard var currentRound,
              currentRound.swapParticipants(firstID: firstID, secondID: secondID)
        else {
            return
        }

        captureUndoSnapshot()
        session.rounds[session.rounds.count - 1] = currentRound
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func undoLastChange() {
        guard let undoSession = undoSessions.popLast() else {
            return
        }

        session = undoSession
        session.updatedAt = Date()
        syncUndoState()
        errorMessage = nil
        saveSession()
    }

    private func defaultSkillLevel(for index: Int) -> SkillLevel {
        SkillLevel(rawValue: (index % SkillLevel.allCases.count) + 1) ?? .beginner
    }

    private func captureUndoSnapshot() {
        undoSessions.append(session)
        if undoSessions.count > undoHistoryLimit {
            undoSessions.removeFirst(undoSessions.count - undoHistoryLimit)
        }
        syncUndoState()
    }

    private func clearUndoHistory() {
        undoSessions = []
        syncUndoState()
    }

    private func syncUndoState() {
        undoCount = undoSessions.count
        canUndo = undoCount > 0
    }

    private func resetParticipantForNewSession(_ participant: Participant) -> Participant {
        var participant = participant
        participant.status = .active
        participant.playCount = 0
        participant.waitingCount = 0
        participant.consecutivePlayCount = 0
        participant.consecutiveWaitCount = 0
        return participant
    }

    private func saveSession() {
        do {
            try sessionRepository?.save(session)
        } catch {
            errorMessage = "セッションを保存できませんでした。端末の空き容量を確認してください。"
        }
    }
}

private extension Round {
    var participantsInRound: [Participant] {
        matches.flatMap { match in
            match.teamA.players + match.teamB.players
        } + waitingParticipants
    }

    mutating func swapParticipants(firstID: Participant.ID, secondID: Participant.ID) -> Bool {
        guard firstID != secondID,
              let first = participantLocation(for: firstID),
              let second = participantLocation(for: secondID)
        else {
            return false
        }

        setParticipant(second.participant, at: first.slot)
        setParticipant(first.participant, at: second.slot)
        return true
    }

    private func participantLocation(for participantID: Participant.ID) -> RoundParticipantLocation? {
        for matchIndex in matches.indices {
            if let playerIndex = matches[matchIndex].teamA.players.firstIndex(where: { $0.id == participantID }) {
                return RoundParticipantLocation(
                    participant: matches[matchIndex].teamA.players[playerIndex],
                    slot: .teamA(matchIndex: matchIndex, playerIndex: playerIndex)
                )
            }
            if let playerIndex = matches[matchIndex].teamB.players.firstIndex(where: { $0.id == participantID }) {
                return RoundParticipantLocation(
                    participant: matches[matchIndex].teamB.players[playerIndex],
                    slot: .teamB(matchIndex: matchIndex, playerIndex: playerIndex)
                )
            }
        }

        if let waitingIndex = waitingParticipants.firstIndex(where: { $0.id == participantID }) {
            return RoundParticipantLocation(
                participant: waitingParticipants[waitingIndex],
                slot: .waiting(index: waitingIndex)
            )
        }

        return nil
    }

    private mutating func setParticipant(_ participant: Participant, at slot: RoundParticipantSlot) {
        switch slot {
        case let .teamA(matchIndex, playerIndex):
            matches[matchIndex].teamA.players[playerIndex] = participant
        case let .teamB(matchIndex, playerIndex):
            matches[matchIndex].teamB.players[playerIndex] = participant
        case let .waiting(index):
            waitingParticipants[index] = participant
        }
    }
}

private struct RoundParticipantLocation {
    var participant: Participant
    var slot: RoundParticipantSlot
}

private enum RoundParticipantSlot {
    case teamA(matchIndex: Int, playerIndex: Int)
    case teamB(matchIndex: Int, playerIndex: Int)
    case waiting(index: Int)
}

extension Session {
    static func defaultSession() -> Session {
        .emptyDaySession()
    }

    static func emptyDaySession() -> Session {
        Session(
            name: "今日のピックルボール",
            courtCount: 2,
            roundDurationMinutes: 12,
            mode: .normalPractice
        )
    }
}
