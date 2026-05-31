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
        XCTAssertEqual(viewModel.errorMessage, "保存済みセッションを読み込めませんでした。新規セッションで開始します。")
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

private final class SpySessionRepository: SessionRepository, @unchecked Sendable {
    private let restoredSession: Session?
    private let loadError: Error?
    var savedSessions: [Session] = []

    init(restoredSession: Session? = nil, loadError: Error? = nil) {
        self.restoredSession = restoredSession
        self.loadError = loadError
    }

    func loadLatestSession() throws -> Session? {
        if let loadError {
            throw loadError
        }
        return restoredSession
    }

    func save(_ session: Session) throws {
        savedSessions.append(session)
    }
}
