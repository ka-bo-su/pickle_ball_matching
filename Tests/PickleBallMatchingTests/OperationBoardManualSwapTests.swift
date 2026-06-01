@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardManualSwapTests: XCTestCase {
    func testSwapCurrentRoundParticipantsExchangesTwoPlayingPlayersAndAutosaves() throws {
        let repository = SpySessionRepository()
        let session = Session(name: "テスト", courtCount: 1, participants: makeParticipants(count: 4))
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)
        viewModel.generateNextRound()
        let originalRound = try XCTUnwrap(viewModel.currentRound)
        let firstPlayer = try XCTUnwrap(originalRound.matches.first?.teamA.players.first)
        let secondPlayer = try XCTUnwrap(originalRound.matches.first?.teamB.players.first)

        viewModel.swapCurrentRoundParticipants(firstID: firstPlayer.id, secondID: secondPlayer.id)

        let updatedRound = try XCTUnwrap(viewModel.currentRound)
        XCTAssertEqual(updatedRound.matches.first?.teamA.players.first?.id, secondPlayer.id)
        XCTAssertEqual(updatedRound.matches.first?.teamB.players.first?.id, firstPlayer.id)
        XCTAssertEqual(repository.savedSessions.last?.currentRound, updatedRound)
        XCTAssertTrue(viewModel.canUndo)

        viewModel.undoLastChange()

        XCTAssertEqual(viewModel.currentRound, originalRound)
    }

    func testSwapCandidatesIncludePlayingPlayersAndWaitersButExcludeSelectedPlayer() throws {
        let session = Session(name: "テスト", courtCount: 1, participants: makeParticipants(count: 5))
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()
        let round = try XCTUnwrap(viewModel.currentRound)
        let selectedPlayer = try XCTUnwrap(round.matches.first?.teamA.players.first)
        let waitingPlayer = try XCTUnwrap(round.waitingParticipants.first)
        let otherPlayingPlayer = try XCTUnwrap(round.matches.first?.teamB.players.first)

        let candidates = viewModel.swapCandidates(for: selectedPlayer.id)
        let candidateIDs = Set(candidates.map(\.id))

        XCTAssertFalse(candidateIDs.contains(selectedPlayer.id))
        XCTAssertTrue(candidateIDs.contains(waitingPlayer.id))
        XCTAssertTrue(candidateIDs.contains(otherPlayingPlayer.id))
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
