@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardSessionHistoryTests: XCTestCase {
    func testInitLoadsSavedSessionsFromRepository() {
        let currentSession = makeSession(idSuffix: 401, name: "今日の練習", updatedAt: 1_717_257_600)
        let previousSession = makeSession(idSuffix: 402, name: "先週の練習", updatedAt: 1_717_171_200)
        let repository = SpySessionRepository(
            restoredSession: currentSession,
            storedSessions: [currentSession, previousSession]
        )

        let viewModel = OperationBoardViewModel(sessionRepository: repository)

        XCTAssertEqual(viewModel.savedSessions.map(\.id), [currentSession.id, previousSession.id])
        XCTAssertEqual(viewModel.savedSessionsForReopen.map(\.id), [previousSession.id])
        XCTAssertEqual(viewModel.savedSessionTitle(previousSession), "先週の練習（4人・0R）")
    }

    func testReopenSessionLoadsSelectedHistoryAndAutosavesAsLatest() {
        let currentSession = makeSession(idSuffix: 501, name: "今日の練習", updatedAt: 1_717_257_600)
        let previousSession = makeSession(idSuffix: 502, name: "先週の練習", updatedAt: 1_717_171_200)
        let repository = SpySessionRepository(
            restoredSession: currentSession,
            storedSessions: [currentSession, previousSession]
        )
        let viewModel = OperationBoardViewModel(sessionRepository: repository)

        viewModel.reopenSession(sessionID: previousSession.id)

        XCTAssertEqual(viewModel.session.id, previousSession.id)
        XCTAssertEqual(repository.savedSessions.last?.id, previousSession.id)
        XCTAssertFalse(viewModel.canUndo)
    }

    private func makeSession(idSuffix: Int, name: String, updatedAt: TimeInterval) -> Session {
        Session(
            id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", idSuffix))!,
            name: name,
            participants: makeParticipants(count: 4),
            updatedAt: Date(timeIntervalSince1970: updatedAt)
        )
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
