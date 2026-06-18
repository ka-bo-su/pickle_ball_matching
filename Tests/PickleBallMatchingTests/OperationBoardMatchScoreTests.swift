@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardMatchScoreTests: XCTestCase {
    func testUpdateCurrentRoundMatchScoreAutosavesScoreAndWinner() throws {
        let repository = MatchScoreSpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: makeSession(),
            sessionRepository: repository
        )
        viewModel.generateNextRound()
        let matchID = try XCTUnwrap(viewModel.currentRound?.matches.first?.id)

        viewModel.updateCurrentRoundMatchScore(
            matchID: matchID,
            teamAScore: 11,
            teamBScore: 8
        )

        let match = try XCTUnwrap(viewModel.currentRound?.matches.first)
        XCTAssertEqual(match.score, MatchScore(teamAScore: 11, teamBScore: 8))
        XCTAssertEqual(match.winner, .teamA)
        XCTAssertEqual(repository.savedSessions.last?.currentRound?.matches.first?.score, match.score)
    }

    func testUpdateCurrentRoundMatchScoreSkipsSaveWhenScoreDoesNotChange() throws {
        let repository = MatchScoreSpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: makeSession(),
            sessionRepository: repository
        )
        viewModel.generateNextRound()
        repository.savedSessions.removeAll()
        let matchID = try XCTUnwrap(viewModel.currentRound?.matches.first?.id)

        viewModel.updateCurrentRoundMatchScore(
            matchID: matchID,
            teamAScore: 0,
            teamBScore: 0
        )

        XCTAssertEqual(repository.savedSessions.count, 1)
        repository.savedSessions.removeAll()

        viewModel.updateCurrentRoundMatchScore(
            matchID: matchID,
            teamAScore: 0,
            teamBScore: 0
        )

        XCTAssertTrue(repository.savedSessions.isEmpty)
    }

    private func makeSession() -> Session {
        Session(
            name: "テスト",
            courtCount: 1,
            participants: makeParticipants(count: 4)
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

final class MatchScoreSpySessionRepository: SessionRepository, @unchecked Sendable {
    var savedSessions: [Session] = []

    func loadLatestSession() throws -> Session? {
        nil
    }

    func loadSavedSessions() throws -> [Session] {
        []
    }

    func save(_ session: Session) throws {
        savedSessions.append(session)
    }
}
