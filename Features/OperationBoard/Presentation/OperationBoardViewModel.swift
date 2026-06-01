import Foundation
import PickleBallMatchingCore

@MainActor
final class OperationBoardViewModel: ObservableObject {
    @Published var session: Session
    @Published var newParticipantName = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var canUndo = false

    private let generateNextRoundUseCase: GenerateNextRoundUseCase
    private let sessionRepository: (any SessionRepository)?
    private let roundExporter: any RoundExporting
    private var undoSession: Session?

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

    func updateSessionName(_ name: String) {
        session.name = name
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func updateRoundDurationMinutes(_ minutes: Int) {
        session.roundDurationMinutes = max(1, minutes)
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func updateOperationMode(_ mode: OperationMode) {
        session.mode = mode
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func startNewSession() {
        session = .emptyDaySession()
        undoSession = nil
        canUndo = false
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
        saveSession()
    }

    func removeParticipants(at offsets: IndexSet) {
        session.participants.remove(atOffsets: offsets)
        session.updatedAt = Date()
        saveSession()
    }

    func updateCourtCount(_ courtCount: Int) {
        session.courtCount = max(1, courtCount)
        session.updatedAt = Date()
        saveSession()
    }

    func updateParticipantStatus(participantID: Participant.ID, status: ParticipantStatus) {
        guard let index = session.participants.firstIndex(where: { $0.id == participantID }) else {
            return
        }

        session.participants[index].status = status
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func updateParticipantSkillLevel(participantID: Participant.ID, skillLevel: SkillLevel) {
        guard let index = session.participants.firstIndex(where: { $0.id == participantID }) else {
            return
        }

        session.participants[index].skillLevel = skillLevel
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func generateNextRound() {
        do {
            session = try generateNextRoundUseCase.execute(session: session)
            errorMessage = nil
            saveSession()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func replaceCurrentRoundPlayer(playerID: Participant.ID, with waitingParticipantID: Participant.ID) {
        guard var currentRound,
              let waitingIndex = currentRound.waitingParticipants.firstIndex(where: { $0.id == waitingParticipantID })
        else {
            return
        }

        let waitingParticipant = currentRound.waitingParticipants[waitingIndex]
        guard let replacement = currentRound.replacePlayer(id: playerID, with: waitingParticipant) else {
            return
        }

        captureUndoSnapshot()
        currentRound.waitingParticipants[waitingIndex] = replacement
        session.rounds[session.rounds.count - 1] = currentRound
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func undoLastChange() {
        guard let undoSession else {
            return
        }

        session = undoSession
        session.updatedAt = Date()
        self.undoSession = nil
        canUndo = false
        errorMessage = nil
        saveSession()
    }

    private func defaultSkillLevel(for index: Int) -> SkillLevel {
        SkillLevel(rawValue: (index % SkillLevel.allCases.count) + 1) ?? .beginner
    }

    private func captureUndoSnapshot() {
        undoSession = session
        canUndo = true
    }

    private func saveSession() {
        do {
            try sessionRepository?.save(session)
        } catch {
            errorMessage = "セッションを保存できませんでした。端末の空き容量を確認してください。"
        }
    }
}

struct LargeBoardDisplayModel: Equatable {
    var sessionName: String
    var roundTitle: String
    var announcement: String
    var courts: [LargeBoardCourtDisplay]
    var waitingPlayerNames: [String]

    var waitingTitle: String {
        waitingPlayerNames.isEmpty ? "待機なし" : "待機者"
    }

    var waitingSummary: String {
        waitingPlayerNames.isEmpty ? "全員がコートに入っています" : waitingPlayerNames.joined(separator: "、")
    }
}

struct LargeBoardCourtDisplay: Equatable, Identifiable {
    var courtNumber: Int
    var teamAPlayerNames: [String]
    var teamBPlayerNames: [String]

    var id: Int {
        courtNumber
    }

    var courtTitle: String {
        "コート\(courtNumber)"
    }

    var accessibilityLabel: String {
        "\(courtTitle)、チームA \(teamAPlayerNames.joined(separator: "、"))、チームB \(teamBPlayerNames.joined(separator: "、"))"
    }
}

private extension Round {
    mutating func replacePlayer(id playerID: Participant.ID, with replacement: Participant) -> Participant? {
        for matchIndex in matches.indices {
            if let replaced = matches[matchIndex].teamA.replacePlayer(id: playerID, with: replacement) {
                return replaced
            }
            if let replaced = matches[matchIndex].teamB.replacePlayer(id: playerID, with: replacement) {
                return replaced
            }
        }
        return nil
    }
}

private extension DoublesTeam {
    mutating func replacePlayer(id playerID: Participant.ID, with replacement: Participant) -> Participant? {
        guard let playerIndex = players.firstIndex(where: { $0.id == playerID }) else {
            return nil
        }

        let replaced = players[playerIndex]
        players[playerIndex] = replacement
        return replaced
    }
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
