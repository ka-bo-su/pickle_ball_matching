@testable import PickleBallMatchingCore
import XCTest

final class GenerateNextRoundUseCaseTests: XCTestCase {
    func testGeneratesExpectedCourtAndWaiterCounts() throws {
        let scenarios: [RoundCountScenario] = [
            RoundCountScenario(participants: 8, courts: 1, expectedMatches: 1, expectedWaiters: 4),
            RoundCountScenario(participants: 10, courts: 2, expectedMatches: 2, expectedWaiters: 2),
            RoundCountScenario(participants: 13, courts: 2, expectedMatches: 2, expectedWaiters: 5),
            RoundCountScenario(participants: 16, courts: 4, expectedMatches: 4, expectedWaiters: 0),
            RoundCountScenario(participants: 17, courts: 3, expectedMatches: 3, expectedWaiters: 5),
            RoundCountScenario(participants: 24, courts: 4, expectedMatches: 4, expectedWaiters: 8)
        ]

        for scenario in scenarios {
            let session = Session(
                name: "人数配分テスト",
                courtCount: scenario.courts,
                participants: makeParticipants(count: scenario.participants)
            )

            let updatedSession = try GenerateNextRoundUseCase().execute(session: session)
            let round = try XCTUnwrap(updatedSession.currentRound)

            XCTAssertEqual(round.matches.count, scenario.expectedMatches)
            XCTAssertEqual(round.waitingParticipants.count, scenario.expectedWaiters)
            let playingCount = round.matches.flatMap { $0.teamA.players + $0.teamB.players }.count
            XCTAssertEqual(playingCount, scenario.expectedMatches * 4)
        }
    }

    func testThrowsWhenAvailableParticipantsAreLessThanFour() {
        let session = Session(name: "不足", participants: makeParticipants(count: 3))

        XCTAssertThrowsError(try GenerateNextRoundUseCase().execute(session: session)) { error in
            XCTAssertEqual(error as? RoundGenerationError, .notEnoughParticipants)
        }
    }

    func testExcludesUnavailableParticipantsFromRound() throws {
        var participants = makeParticipants(count: 8)
        participants[0].status = .wantsBreak
        participants[1].status = .late
        let session = Session(name: "状態反映", courtCount: 2, participants: participants)

        let updatedSession = try GenerateNextRoundUseCase().execute(session: session)
        let round = try XCTUnwrap(updatedSession.currentRound)
        let playedNames = Set(round.matches.flatMap { ($0.teamA.players + $0.teamB.players).map(\.displayName) })

        XCTAssertFalse(playedNames.contains("参加者1"))
        XCTAssertFalse(playedNames.contains("参加者2"))
        XCTAssertEqual(round.matches.count, 1)
    }

    func testPreviousWaitersArePrioritizedInNextRound() throws {
        let participants = makeParticipants(count: 10)
        let previousRound = Round(
            number: 1,
            matches: [],
            waitingParticipants: Array(participants.suffix(2))
        )
        let session = Session(
            name: "連続待機回避",
            courtCount: 2,
            participants: participants,
            rounds: [previousRound]
        )

        let updatedSession = try GenerateNextRoundUseCase().execute(session: session)
        let round = try XCTUnwrap(updatedSession.currentRound)
        let playedIDs = Set(round.matches.flatMap { ($0.teamA.players + $0.teamB.players).map(\.id) })

        XCTAssertTrue(playedIDs.contains(participants[8].id))
        XCTAssertTrue(playedIDs.contains(participants[9].id))
    }

    func testLevelBalancingKeepsTeamsCloseOnEachCourt() throws {
        let session = Session(
            name: "レベル均等",
            courtCount: 2,
            participants: makeParticipants(count: 8)
        )

        let updatedSession = try GenerateNextRoundUseCase().execute(session: session)
        let round = try XCTUnwrap(updatedSession.currentRound)

        for match in round.matches {
            XCTAssertLessThanOrEqual(abs(match.teamA.skillTotal - match.teamB.skillTotal), 1)
        }
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

private struct RoundCountScenario {
    let participants: Int
    let courts: Int
    let expectedMatches: Int
    let expectedWaiters: Int
}
