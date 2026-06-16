import Foundation
import PickleBallMatchingCore

@MainActor
final class OperationBoardViewModel: ObservableObject {
    @Published var session: Session
    @Published var newParticipantName = ""
    @Published var bulkParticipantNames = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var canUndo = false
    @Published private(set) var undoCount = 0
    @Published private(set) var savedSessions: [Session] = []

    private let generateNextRoundUseCase: GenerateNextRoundUseCase
    private let sessionRepository: (any SessionRepository)?
    let roundExporter: any RoundExporting
    let pdfExporter: any RoundPDFExporting
    let imageExporter: any RoundImageExporting
    private let undoHistoryLimit = 10
    private var undoSessions: [Session] = []

    init(
        session: Session? = nil,
        generateNextRoundUseCase: GenerateNextRoundUseCase = GenerateNextRoundUseCase(),
        sessionRepository: (any SessionRepository)? = nil,
        roundExporter: any RoundExporting = CSVRoundExporter(),
        pdfExporter: any RoundPDFExporting = PDFRoundExporter(),
        imageExporter: any RoundImageExporting = ImageRoundExporter()
    ) {
        self.generateNextRoundUseCase = generateNextRoundUseCase
        self.sessionRepository = sessionRepository
        self.roundExporter = roundExporter
        self.pdfExporter = pdfExporter
        self.imageExporter = imageExporter

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

        loadSavedSessions()
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
        guard session.mode != mode else {
            return
        }

        session.mode = mode
        session.ruleSet = mode.defaultRuleSet
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

    func reopenSession(sessionID: Session.ID) {
        guard let savedSession = savedSessions.first(where: { $0.id == sessionID }) else {
            return
        }

        session = savedSession
        clearUndoHistory()
        errorMessage = nil
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

    private func captureUndoSnapshot() {
        undoSessions.append(session)
        if undoSessions.count > undoHistoryLimit {
            undoSessions.removeFirst(undoSessions.count - undoHistoryLimit)
        }
        syncUndoState()
    }

    func clearUndoHistory() {
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

    func persistSessionMutation() {
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    private func saveSession() {
        do {
            try sessionRepository?.save(session)
            syncSavedSessionCache(with: session)
        } catch {
            errorMessage = "セッションを保存できませんでした。端末の空き容量を確認してください。"
        }
    }

    private func loadSavedSessions() {
        do {
            savedSessions = try sessionRepository?.loadSavedSessions() ?? []
        } catch {
            savedSessions = []
            if errorMessage == nil {
                errorMessage = "保存済みセッション一覧を読み込めませんでした。"
            }
        }
    }

    private func syncSavedSessionCache(with session: Session) {
        savedSessions.removeAll { $0.id == session.id }
        savedSessions.append(session)
        savedSessions.sort { lhs, rhs in
            lhs.updatedAt > rhs.updatedAt
        }
    }
}

extension OperationBoardViewModel {
    var currentRound: Round? {
        session.currentRound
    }

    var largeBoardDisplayModel: LargeBoardDisplayModel? {
        largeBoardDisplayModel(now: Date())
    }

    func largeBoardDisplayModel(now: Date) -> LargeBoardDisplayModel? {
        guard let currentRound else {
            return nil
        }

        let waitingNames = currentRound.waitingParticipants.map(\.displayName)
        let timing = OperationBoardRoundTimingModel(
            round: currentRound,
            durationMinutes: session.roundDurationMinutes,
            now: now
        )
        return LargeBoardDisplayModel(
            sessionName: session.name,
            roundTitle: "ラウンド\(currentRound.number)",
            roundStatusTitle: timing.statusTitle,
            remainingTimeText: timing.remainingTimeText,
            timingDetailText: timing.detailText,
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

    var roundHistoryDisplayModel: RoundHistoryDisplayModel {
        RoundHistoryDisplayModel(session: session)
    }

    var canGenerateRound: Bool {
        session.participants.count(where: { $0.status.isAvailableForRound }) >= 4
    }

    var isCurrentRoundInProgress: Bool {
        guard let round = currentRound else { return false }
        return round.startedAt != nil && round.finishedAt == nil
    }

    var undoButtonTitle: String {
        undoCount > 0 ? "1手戻す（\(undoCount)）" : "1手戻す"
    }

    var undoButtonAccessibilityLabel: String {
        undoCount > 0 ? "直前の入れ替えを1手戻す。戻せる操作は\(undoCount)件です。" : "直前の入れ替えを1手戻す"
    }

    var savedSessionsForReopen: [Session] {
        savedSessions.filter { $0.id != session.id }
    }

    func deleteSavedSession(sessionID: Session.ID) {
        guard sessionID != session.id else {
            return
        }

        do {
            try sessionRepository?.deleteSavedSession(id: sessionID)
            savedSessions.removeAll { $0.id == sessionID }
            errorMessage = nil
        } catch {
            errorMessage = "保存済みセッションを削除できませんでした。ファイルの権限や空き容量を確認してください。"
        }
    }

    func savedSessionTitle(_ savedSession: Session) -> String {
        "\(savedSession.name)（\(savedSession.participants.count)人・\(savedSession.rounds.count)R）"
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
            mode: .normalPractice,
            ruleSet: OperationMode.normalPractice.defaultRuleSet
        )
    }
}
