import PickleBallMatchingCore
import XCTest

final class MatchScoreTests: XCTestCase {
    func testWinnerIsTeamAWhenTeamAScoreIsHigher() {
        let score = MatchScore(teamAScore: 11, teamBScore: 7)

        XCTAssertEqual(score.winner, .teamA)
    }

    func testWinnerIsTeamBWhenTeamBScoreIsHigher() {
        let score = MatchScore(teamAScore: 8, teamBScore: 11)

        XCTAssertEqual(score.winner, .teamB)
    }

    func testWinnerIsDrawWhenScoresAreEqual() {
        let score = MatchScore(teamAScore: 10, teamBScore: 10)

        XCTAssertEqual(score.winner, .draw)
    }

    func testMatchWithoutScoreHasNotRecordedWinner() {
        let match = Match(
            courtNumber: 1,
            teamA: DoublesTeam(players: []),
            teamB: DoublesTeam(players: [])
        )

        XCTAssertEqual(match.winner, .notRecorded)
    }

    func testNegativeScoresAreClampedToZero() {
        let score = MatchScore(teamAScore: -1, teamBScore: -3)

        XCTAssertEqual(score.teamAScore, 0)
        XCTAssertEqual(score.teamBScore, 0)
    }
}
