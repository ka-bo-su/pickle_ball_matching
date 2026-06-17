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

    func testAvoidsRepeatedPairsWhenGeneratingNextRound() throws {
        let useCase = GenerateNextRoundUseCase()
        let firstSession = try useCase.execute(
            session: Session(
                name: "同ペア回避",
                courtCount: 1,
                participants: makeParticipants(count: 4)
            )
        )
        let firstRound = try XCTUnwrap(firstSession.currentRound)

        let secondSession = try useCase.execute(session: firstSession)
        let secondRound = try XCTUnwrap(secondSession.currentRound)

        XCTAssertTrue(teamPairs(in: firstRound).isDisjoint(with: teamPairs(in: secondRound)))
    }

    func testRepeatedPairAvoidanceCanBeDisabled() throws {
        var ruleSet = SessionRuleSet.balancedPractice
        ruleSet.avoidsRepeatedPairs = false
        ruleSet.avoidsRepeatedOpponents = false
        let useCase = GenerateNextRoundUseCase()
        let firstSession = try useCase.execute(
            session: Session(
                name: "同ペア回避なし",
                courtCount: 1,
                participants: makeParticipants(count: 4),
                ruleSet: ruleSet
            )
        )
        let firstRound = try XCTUnwrap(firstSession.currentRound)

        let secondSession = try useCase.execute(session: firstSession)
        let secondRound = try XCTUnwrap(secondSession.currentRound)

        XCTAssertEqual(teamPairs(in: firstRound), teamPairs(in: secondRound))
    }

    func testAvoidsRepeatedOpponentsWhenPairAvoidanceIsDisabled() throws {
        var ruleSet = SessionRuleSet.balancedPractice
        ruleSet.avoidsRepeatedPairs = false
        ruleSet.avoidsRepeatedOpponents = true
        let useCase = GenerateNextRoundUseCase()
        let firstSession = try useCase.execute(
            session: Session(
                name: "同対戦相手回避",
                courtCount: 1,
                participants: makeParticipants(count: 4),
                ruleSet: ruleSet
            )
        )
        let firstRound = try XCTUnwrap(firstSession.currentRound)

        let secondSession = try useCase.execute(session: firstSession)
        let secondRound = try XCTUnwrap(secondSession.currentRound)
        let repeatedOpponentPairs = opponentPairs(in: firstRound).intersection(opponentPairs(in: secondRound))

        XCTAssertLessThan(repeatedOpponentPairs.count, opponentPairs(in: firstRound).count)
    }

    func testRepeatedOpponentAvoidanceCanBeDisabled() throws {
        var ruleSet = SessionRuleSet.balancedPractice
        ruleSet.avoidsRepeatedPairs = false
        ruleSet.avoidsRepeatedOpponents = false
        let useCase = GenerateNextRoundUseCase()
        let firstSession = try useCase.execute(
            session: Session(
                name: "同対戦相手回避なし",
                courtCount: 1,
                participants: makeParticipants(count: 4),
                ruleSet: ruleSet
            )
        )
        let firstRound = try XCTUnwrap(firstSession.currentRound)

        let secondSession = try useCase.execute(session: firstSession)
        let secondRound = try XCTUnwrap(secondSession.currentRound)

        XCTAssertEqual(opponentPairs(in: firstRound), opponentPairs(in: secondRound))
    }

    func testProtectsBeginnersReducesExposureToAdvancedOpponents() throws {
        let participants = [
            Participant(displayName: "初心者A", skillLevel: .beginner),
            Participant(displayName: "初心者B", skillLevel: .beginner),
            Participant(displayName: "上級者C", skillLevel: .advanced),
            Participant(displayName: "上級者D", skillLevel: .advanced)
        ]
        var protectedRuleSet = SessionRuleSet.balancedPractice
        protectedRuleSet.protectsBeginners = true
        protectedRuleSet.reducesLevelGap = false
        protectedRuleSet.avoidsRepeatedPairs = false
        protectedRuleSet.avoidsRepeatedOpponents = false

        let session = Session(
            name: "初心者保護テスト",
            courtCount: 1,
            participants: participants,
            ruleSet: protectedRuleSet
        )

        let result = try GenerateNextRoundUseCase().execute(session: session)
        let round = try XCTUnwrap(result.currentRound)
        let match = try XCTUnwrap(round.matches.first)

        let teamASkills = Set(match.teamA.players.map(\.skillLevel))
        let teamBSkills = Set(match.teamB.players.map(\.skillLevel))
        let beginnerOnlyTeam = teamASkills == [.beginner] || teamBSkills == [.beginner]
        XCTAssertFalse(
            beginnerOnlyTeam,
            "初心者保護ONでは初心者だけのチームが上級者だけのチームと対戦すべきでない"
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

    private func teamPairs(in round: Round) -> Set<TestPlayerPair> {
        Set(round.matches.flatMap { match in
            [
                TestPlayerPair(match.teamA.players),
                TestPlayerPair(match.teamB.players)
            ]
        })
    }

    private func opponentPairs(in round: Round) -> Set<TestPlayerPair> {
        Set(round.matches.flatMap { match in
            match.teamA.players.flatMap { teamAPlayer in
                match.teamB.players.map { teamBPlayer in
                    TestPlayerPair([teamAPlayer, teamBPlayer])
                }
            }
        })
    }
}

private struct TestPlayerPair: Hashable {
    private let first: UUID
    private let second: UUID

    init(_ players: [Participant]) {
        let ids = players.map(\.id).sorted { lhs, rhs in
            lhs.uuidString < rhs.uuidString
        }
        first = ids[0]
        second = ids[1]
    }
}

private struct RoundCountScenario {
    let participants: Int
    let courts: Int
    let expectedMatches: Int
    let expectedWaiters: Int
}
