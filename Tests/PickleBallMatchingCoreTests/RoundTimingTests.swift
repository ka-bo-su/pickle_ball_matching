import PickleBallMatchingCore
import XCTest

final class RoundTimingTests: XCTestCase {
    func testScheduledRoundReturnsFullRemainingDuration() {
        let round = makeRound()

        XCTAssertEqual(round.status, .scheduled)
        XCTAssertEqual(round.remainingSeconds(durationMinutes: 12, now: referenceDate), 720)
    }

    func testInProgressRoundReturnsRemainingSeconds() {
        let round = makeRound(startedAt: referenceDate)

        XCTAssertEqual(round.status, .inProgress)
        XCTAssertEqual(
            round.remainingSeconds(
                durationMinutes: 12,
                now: referenceDate.addingTimeInterval(90)
            ),
            630
        )
    }

    func testFinishedRoundReturnsZeroRemainingSeconds() {
        let round = makeRound(startedAt: referenceDate, finishedAt: referenceDate.addingTimeInterval(300))

        XCTAssertEqual(round.status, .finished)
        XCTAssertEqual(
            round.remainingSeconds(
                durationMinutes: 12,
                now: referenceDate.addingTimeInterval(360)
            ),
            0
        )
    }

    func testExpiredRoundDoesNotReturnNegativeRemainingSeconds() {
        let round = makeRound(startedAt: referenceDate)

        XCTAssertEqual(
            round.remainingSeconds(
                durationMinutes: 1,
                now: referenceDate.addingTimeInterval(120)
            ),
            0
        )
    }

    private var referenceDate: Date {
        Date(timeIntervalSince1970: 1_700_000_000)
    }

    private func makeRound(startedAt: Date? = nil, finishedAt: Date? = nil) -> Round {
        Round(
            number: 1,
            matches: [],
            waitingParticipants: [],
            startedAt: startedAt,
            finishedAt: finishedAt
        )
    }
}
