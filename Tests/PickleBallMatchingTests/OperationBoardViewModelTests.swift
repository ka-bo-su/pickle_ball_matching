@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardViewModelTests: XCTestCase {
    func testAddParticipantAppendsTrimmedName() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト", participants: []))
        viewModel.newParticipantName = "  山田  "

        viewModel.addParticipant()

        XCTAssertEqual(viewModel.session.participants.map(\.displayName), ["山田"])
        XCTAssertEqual(viewModel.newParticipantName, "")
    }

    func testCanAddParticipantRequiresNonBlankName() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト", participants: []))

        viewModel.newParticipantName = "   "
        XCTAssertFalse(viewModel.canAddParticipant)

        viewModel.newParticipantName = "山田"
        XCTAssertTrue(viewModel.canAddParticipant)
    }

    func testCanAddParticipantRejectsDuplicateName() {
        let viewModel = OperationBoardViewModel(
            session: Session(
                name: "テスト",
                participants: [
                    Participant(displayName: "山田")
                ]
            )
        )

        viewModel.newParticipantName = "  山田  "

        XCTAssertFalse(viewModel.canAddParticipant)
        XCTAssertEqual(
            viewModel.participantNameInputWarning,
            "同じ名前の参加者がいます。名字やメモを足して区別してください。"
        )
    }

    func testAddParticipantDoesNotAppendDuplicateName() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(
                name: "テスト",
                participants: [
                    Participant(displayName: "Yamada")
                ]
            ),
            sessionRepository: repository
        )
        viewModel.newParticipantName = " yamada "

        viewModel.addParticipant()

        XCTAssertEqual(viewModel.session.participants.map(\.displayName), ["Yamada"])
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(repository.savedSessions.isEmpty)
    }

    func testGenerateNextRoundUpdatesCurrentRoundAndWaiters() {
        let session = Session(
            name: "テスト",
            courtCount: 2,
            participants: makeParticipants(count: 10)
        )
        let viewModel = OperationBoardViewModel(session: session)

        viewModel.generateNextRound()

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.currentRound?.matches.count, 2)
        XCTAssertEqual(viewModel.currentRound?.waitingParticipants.count, 2)
    }

    func testGenerateNextRoundShowsErrorWhenParticipantsAreInsufficient() {
        let session = Session(name: "テスト", participants: makeParticipants(count: 3))
        let viewModel = OperationBoardViewModel(session: session)

        viewModel.generateNextRound()

        XCTAssertEqual(viewModel.errorMessage, "参加可能な人が4人未満です。")
        XCTAssertNil(viewModel.currentRound)
    }

    func testInitRestoresLatestSessionFromRepository() {
        let restoredSession = Session(name: "復元セッション", participants: makeParticipants(count: 4))
        let repository = SpySessionRepository(restoredSession: restoredSession)

        let viewModel = OperationBoardViewModel(sessionRepository: repository)

        XCTAssertEqual(viewModel.session.name, "復元セッション")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testAddParticipantAutosavesSession() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "テスト", participants: []),
            sessionRepository: repository
        )
        viewModel.newParticipantName = "山田"

        viewModel.addParticipant()

        XCTAssertEqual(repository.savedSessions.last?.participants.map(\.displayName), ["山田"])
    }

    func testInitUsesDefaultSessionAndShowsMessageWhenRestoreFails() {
        let repository = SpySessionRepository(loadError: SessionPersistenceError.decodingFailed("broken"))

        let viewModel = OperationBoardViewModel(sessionRepository: repository)

        XCTAssertEqual(viewModel.session.name, "今日のピックルボール")
        XCTAssertTrue(viewModel.session.participants.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "保存済みセッションを読み込めませんでした。新規セッションで開始します。")
    }

    func testUpdateSessionNameAutosaves() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "変更前"),
            sessionRepository: repository
        )

        viewModel.updateSessionName("初心者体験会")

        XCTAssertEqual(viewModel.session.name, "初心者体験会")
        XCTAssertEqual(repository.savedSessions.last?.name, "初心者体験会")
    }

    func testUpdateRoundDurationAutosaves() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "テスト", roundDurationMinutes: 12),
            sessionRepository: repository
        )

        viewModel.updateRoundDurationMinutes(15)

        XCTAssertEqual(viewModel.session.roundDurationMinutes, 15)
        XCTAssertEqual(repository.savedSessions.last?.roundDurationMinutes, 15)
    }

    func testStartNewSessionClearsParticipantsRoundsAndAutosaves() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "古い会", courtCount: 1, participants: makeParticipants(count: 5)),
            sessionRepository: repository
        )
        viewModel.generateNextRound()

        viewModel.startNewSession()

        XCTAssertEqual(viewModel.session.name, "今日のピックルボール")
        XCTAssertEqual(viewModel.session.courtCount, 2)
        XCTAssertEqual(viewModel.session.roundDurationMinutes, 12)
        XCTAssertEqual(viewModel.session.mode, .normalPractice)
        XCTAssertTrue(viewModel.session.participants.isEmpty)
        XCTAssertTrue(viewModel.session.rounds.isEmpty)
        XCTAssertFalse(viewModel.canUndo)
        XCTAssertEqual(repository.savedSessions.last?.participants, [])
    }

    func testUpdateParticipantStatusChangesStatusAndAutosaves() throws {
        let repository = SpySessionRepository()
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let session = Session(
            name: "テスト",
            participants: [
                Participant(id: participantID, displayName: "山田")
            ]
        )
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.updateParticipantStatus(participantID: participantID, status: .wantsBreak)

        XCTAssertEqual(viewModel.session.participants.first?.status, .wantsBreak)
        XCTAssertEqual(repository.savedSessions.last?.participants.first?.status, .wantsBreak)
    }

    func testToggleParticipantAttendanceSwitchesBetweenAbsentAndActiveAndAutosaves() throws {
        let repository = SpySessionRepository()
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let session = Session(
            name: "テスト",
            participants: [
                Participant(id: participantID, displayName: "山田", status: .active)
            ]
        )
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.toggleParticipantAttendance(participantID: participantID)

        XCTAssertEqual(viewModel.session.participants.first?.status, .absent)
        XCTAssertEqual(repository.savedSessions.last?.participants.first?.status, .absent)

        viewModel.toggleParticipantAttendance(participantID: participantID)

        XCTAssertEqual(viewModel.session.participants.first?.status, .active)
        XCTAssertEqual(repository.savedSessions.last?.participants.first?.status, .active)
    }

    func testRemoveParticipantRemovesFromRosterAndAutosaves() throws {
        let repository = SpySessionRepository()
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let session = Session(
            name: "テスト",
            participants: [
                Participant(id: participantID, displayName: "山田"),
                Participant(displayName: "佐藤")
            ]
        )
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.removeParticipant(participantID: participantID)

        XCTAssertEqual(viewModel.session.participants.map(\.displayName), ["佐藤"])
        XCTAssertEqual(repository.savedSessions.last?.participants.map(\.displayName), ["佐藤"])
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGenerateNextRoundExcludesUnavailableStatuses() {
        var participants = makeParticipants(count: 6)
        participants[0].status = .wantsBreak
        participants[1].status = .absent
        let session = Session(name: "テスト", courtCount: 1, participants: participants)
        let viewModel = OperationBoardViewModel(session: session)

        viewModel.generateNextRound()

        let roundParticipants = viewModel.currentRound?.matches.flatMap { match in
            match.teamA.players + match.teamB.players
        } ?? []
        let roundIDs = Set(roundParticipants.map(\.id))
        XCTAssertFalse(roundIDs.contains(participants[0].id))
        XCTAssertFalse(roundIDs.contains(participants[1].id))
        XCTAssertEqual(roundParticipants.count, 4)
    }

    func testReplaceCurrentRoundPlayerWithWaiterUpdatesRoundAndAutosaves() throws {
        let repository = SpySessionRepository()
        let session = Session(name: "テスト", courtCount: 1, participants: makeParticipants(count: 5))
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)
        viewModel.generateNextRound()
        let round = try XCTUnwrap(viewModel.currentRound)
        let playingParticipant = try XCTUnwrap(round.matches.first?.teamA.players.first)
        let waitingParticipant = try XCTUnwrap(round.waitingParticipants.first)

        viewModel.replaceCurrentRoundPlayer(playerID: playingParticipant.id, with: waitingParticipant.id)

        let updatedRound = try XCTUnwrap(viewModel.currentRound)
        let playingIDs = Set(updatedRound.playingParticipants.map(\.id))
        XCTAssertTrue(playingIDs.contains(waitingParticipant.id))
        XCTAssertFalse(playingIDs.contains(playingParticipant.id))
        XCTAssertEqual(updatedRound.waitingParticipants.map(\.id), [playingParticipant.id])
        XCTAssertEqual(repository.savedSessions.last?.currentRound, updatedRound)
        XCTAssertTrue(viewModel.canUndo)
    }

    func testUndoLastChangeRestoresPreviousRoundAndAutosaves() throws {
        let repository = SpySessionRepository()
        let session = Session(name: "テスト", courtCount: 1, participants: makeParticipants(count: 5))
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)
        viewModel.generateNextRound()
        let originalRound = try XCTUnwrap(viewModel.currentRound)
        let playingParticipant = try XCTUnwrap(originalRound.matches.first?.teamA.players.first)
        let waitingParticipant = try XCTUnwrap(originalRound.waitingParticipants.first)
        viewModel.replaceCurrentRoundPlayer(playerID: playingParticipant.id, with: waitingParticipant.id)

        viewModel.undoLastChange()

        XCTAssertEqual(viewModel.currentRound, originalRound)
        XCTAssertFalse(viewModel.canUndo)
        XCTAssertEqual(repository.savedSessions.last?.currentRound, originalRound)
    }

    func testUndoLastChangeDoesNothingWithoutSnapshot() {
        let session = Session(name: "テスト", participants: makeParticipants(count: 4))
        let viewModel = OperationBoardViewModel(session: session)

        viewModel.undoLastChange()

        XCTAssertEqual(viewModel.session, session)
        XCTAssertFalse(viewModel.canUndo)
    }

    func testCurrentRoundCSVExportsCurrentRound() {
        let session = Session(name: "テスト", courtCount: 1, participants: makeParticipants(count: 5))
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()

        let csv = viewModel.currentRoundCSV

        XCTAssertNotNil(csv)
        XCTAssertTrue(csv?.contains("セッション,テスト") == true)
        XCTAssertTrue(csv?.contains("ラウンド,1") == true)
    }

    func testCurrentRoundCSVIsNilBeforeRoundGeneration() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト"))

        XCTAssertNil(viewModel.currentRoundCSV)
    }

    func testCurrentRoundPDFDocumentExportsCurrentRound() throws {
        let session = Session(name: "初心者/体験会", courtCount: 1, participants: makeParticipants(count: 5))
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()

        let pdfDocument = try XCTUnwrap(viewModel.currentRoundPDFDocument)

        XCTAssertEqual(String(data: pdfDocument.data.prefix(4), encoding: .ascii), "%PDF")
        XCTAssertEqual(pdfDocument.fileName, "初心者-体験会-round-1.pdf")
    }

    func testCurrentRoundPDFDocumentIsNilBeforeRoundGeneration() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト"))

        XCTAssertNil(viewModel.currentRoundPDFDocument)
    }

    func testCurrentRoundImageDocumentExportsCurrentRound() throws {
        let session = Session(name: "初心者/体験会", courtCount: 1, participants: makeParticipants(count: 5))
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()

        let imageDocument = try XCTUnwrap(viewModel.currentRoundImageDocument)

        XCTAssertEqual(Array(imageDocument.data.prefix(8)), [137, 80, 78, 71, 13, 10, 26, 10])
        XCTAssertEqual(imageDocument.fileName, "初心者-体験会-round-1.png")
    }

    func testCurrentRoundImageDocumentIsNilBeforeRoundGeneration() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト"))

        XCTAssertNil(viewModel.currentRoundImageDocument)
    }

    private func makeParticipants(count: Int) -> [Participant] {
        (1 ... count).map { index in
            Participant(
                id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", index))!,
                displayName: "参加者\(index)",
                skillLevel: SkillLevel(rawValue: (index % 4) + 1) ?? .beginner
            )
        }
    }
}

private extension Round {
    var playingParticipants: [Participant] {
        matches.flatMap { match in
            match.teamA.players + match.teamB.players
        }
    }
}

final class SpySessionRepository: SessionRepository, @unchecked Sendable {
    private let restoredSession: Session?
    private var storedSessions: [Session]
    private let loadError: Error?
    var savedSessions: [Session] = []
    var deletedSessionIDs: [Session.ID] = []

    init(restoredSession: Session? = nil, storedSessions: [Session] = [], loadError: Error? = nil) {
        self.restoredSession = restoredSession
        self.storedSessions = storedSessions
        self.loadError = loadError
    }

    func loadLatestSession() throws -> Session? {
        if let loadError {
            throw loadError
        }
        return restoredSession
    }

    func loadSavedSessions() throws -> [Session] {
        if let loadError {
            throw loadError
        }
        return storedSessions
    }

    func save(_ session: Session) throws {
        savedSessions.append(session)
    }

    func deleteSavedSession(id: Session.ID) throws {
        deletedSessionIDs.append(id)
        storedSessions.removeAll { $0.id == id }
    }
}
