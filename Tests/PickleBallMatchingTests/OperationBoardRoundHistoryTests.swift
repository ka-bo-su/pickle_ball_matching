@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardRoundHistoryTests: XCTestCase {
    func testRoundHistoryDisplayModelIsEmptyBeforeRoundGeneration() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト"))

        let model = viewModel.roundHistoryDisplayModel

        XCTAssertTrue(model.isEmpty)
        XCTAssertTrue(model.rounds.isEmpty)
    }

    func testRoundHistoryDisplayModelShowsNewestRoundsFirstWithScoresAndWaiters() {
        let participants = makeParticipants(count: 6)
        let firstRound = Round(
            number: 1,
            matches: [
                Match(
                    courtNumber: 1,
                    teamA: DoublesTeam(players: [participants[0], participants[1]]),
                    teamB: DoublesTeam(players: [participants[2], participants[3]]),
                    status: .finished,
                    score: MatchScore(teamAScore: 11, teamBScore: 8)
                )
            ],
            waitingParticipants: [participants[4], participants[5]],
            finishedAt: Date()
        )
        let secondRound = Round(
            number: 2,
            matches: [
                Match(
                    courtNumber: 1,
                    teamA: DoublesTeam(players: [participants[4], participants[5]]),
                    teamB: DoublesTeam(players: [participants[0], participants[2]])
                )
            ],
            waitingParticipants: []
        )
        let session = Session(
            name: "テスト",
            participants: participants,
            rounds: [firstRound, secondRound]
        )
        let viewModel = OperationBoardViewModel(session: session)

        let model = viewModel.roundHistoryDisplayModel

        XCTAssertEqual(model.rounds.map(\.title), ["ラウンド2", "ラウンド1"])
        XCTAssertEqual(model.rounds[0].statusText, "未開始")
        XCTAssertEqual(model.rounds[0].waitingSummary, "待機なし")
        XCTAssertEqual(model.rounds[1].waitingSummary, "待機: 参加者5、参加者6")
        XCTAssertEqual(model.rounds[1].matches.first?.scoreSummary, "スコア A 11 - B 8")
        XCTAssertEqual(model.rounds[1].matches.first?.winnerSummary, "チームA勝利")
        XCTAssertTrue(model.rounds[1].accessibilityLabel.contains("結果 チームA勝利"))
    }

    private func makeParticipants(count: Int) -> [Participant] {
        (1 ... count).map { index in
            Participant(
                id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", index))!,
                displayName: "参加者\(index)"
            )
        }
    }
}
