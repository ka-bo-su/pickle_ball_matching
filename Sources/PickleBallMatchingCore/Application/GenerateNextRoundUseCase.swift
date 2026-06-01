import Foundation

public struct GenerateNextRoundUseCase: Sendable {
    public init() {}

    public func execute(session: Session) throws -> Session {
        let availableParticipants = session.participants.filter(\.status.isAvailableForRound)
        guard availableParticipants.count >= 4 else {
            throw RoundGenerationError.notEnoughParticipants
        }

        let playableCourtCount = max(1, min(session.courtCount, availableParticipants.count / 4))
        let playSlotCount = playableCourtCount * 4
        let selectedParticipants = selectParticipantsToPlay(
            from: availableParticipants,
            slotCount: playSlotCount,
            previousRound: session.currentRound,
            ruleSet: session.ruleSet
        )
        let selectedIDs = Set(selectedParticipants.map(\.id))
        let waitingParticipants = availableParticipants
            .filter { !selectedIDs.contains($0.id) }
            .sortedForDisplay()

        let matchHistory = MatchHistory(rounds: session.rounds)
        let matches = makeMatches(
            from: selectedParticipants,
            courtCount: playableCourtCount,
            history: matchHistory,
            ruleSet: session.ruleSet
        )
        let round = Round(
            number: session.rounds.count + 1,
            matches: matches,
            waitingParticipants: waitingParticipants
        )

        var updatedSession = session
        updatedSession.rounds.append(round)
        updatedSession.participants = updateParticipantCounters(
            session.participants,
            playingIDs: selectedIDs,
            waitingIDs: Set(waitingParticipants.map(\.id))
        )
        updatedSession.updatedAt = Date()
        return updatedSession
    }

    private func selectParticipantsToPlay(
        from participants: [Participant],
        slotCount: Int,
        previousRound: Round?,
        ruleSet: SessionRuleSet
    ) -> [Participant] {
        let previousWaitingIDs = Set(previousRound?.waitingParticipants.map(\.id) ?? [])
        let sortedParticipants = participants
            .sorted { lhs, rhs in
                let lhsScore = playPriority(
                    for: lhs,
                    previousWaitingIDs: previousWaitingIDs,
                    ruleSet: ruleSet
                )
                let rhsScore = playPriority(
                    for: rhs,
                    previousWaitingIDs: previousWaitingIDs,
                    ruleSet: ruleSet
                )
                if lhsScore == rhsScore {
                    return lhs.displayName.localizedStandardCompare(rhs.displayName) == .orderedAscending
                }
                return lhsScore > rhsScore
            }
        return Array(sortedParticipants.prefix(slotCount))
            .sortedForCourtAssignment()
    }

    private func playPriority(
        for participant: Participant,
        previousWaitingIDs: Set<UUID>,
        ruleSet: SessionRuleSet
    ) -> Int {
        var score = participant.waitingCount * 10
        if ruleSet.avoidsConsecutiveWaiting, previousWaitingIDs.contains(participant.id) {
            score += 40
        }
        if ruleSet.balancesWaitingCount {
            score -= participant.playCount
        }
        score -= participant.consecutivePlayCount * 2
        score += participant.consecutiveWaitCount * 8
        return score
    }

    private func makeMatches(
        from participants: [Participant],
        courtCount: Int,
        history: MatchHistory,
        ruleSet: SessionRuleSet
    ) -> [Match] {
        (0 ..< courtCount).map { index in
            let startIndex = index * 4
            let group = Array(participants[startIndex ..< startIndex + 4])
                .sorted { lhs, rhs in
                    if lhs.skillLevel.rawValue == rhs.skillLevel.rawValue {
                        return lhs.displayName.localizedStandardCompare(rhs.displayName) == .orderedAscending
                    }
                    return lhs.skillLevel.rawValue > rhs.skillLevel.rawValue
                }
            return bestMatch(
                for: group,
                courtNumber: index + 1,
                history: history,
                ruleSet: ruleSet
            )
        }
    }

    private func bestMatch(
        for group: [Participant],
        courtNumber: Int,
        history: MatchHistory,
        ruleSet: SessionRuleSet
    ) -> Match {
        matchCandidates(for: group, courtNumber: courtNumber)
            .enumerated()
            .min { lhs, rhs in
                let lhsPenalty = matchPenalty(lhs.element, history: history, ruleSet: ruleSet)
                let rhsPenalty = matchPenalty(rhs.element, history: history, ruleSet: ruleSet)
                if lhsPenalty == rhsPenalty {
                    return lhs.offset < rhs.offset
                }
                return lhsPenalty < rhsPenalty
            }?
            .element ?? Match(
                courtNumber: courtNumber,
                teamA: DoublesTeam(players: [group[0], group[3]]),
                teamB: DoublesTeam(players: [group[1], group[2]])
            )
    }

    private func matchCandidates(for group: [Participant], courtNumber: Int) -> [Match] {
        [
            ([group[0], group[3]], [group[1], group[2]]),
            ([group[0], group[1]], [group[2], group[3]]),
            ([group[0], group[2]], [group[1], group[3]])
        ].map { teamAPlayers, teamBPlayers in
            Match(
                courtNumber: courtNumber,
                teamA: DoublesTeam(players: teamAPlayers),
                teamB: DoublesTeam(players: teamBPlayers)
            )
        }
    }

    private func matchPenalty(
        _ match: Match,
        history: MatchHistory,
        ruleSet: SessionRuleSet
    ) -> Int {
        var penalty = 0
        if ruleSet.reducesLevelGap {
            penalty += abs(match.teamA.skillTotal - match.teamB.skillTotal) * 10
        }
        if ruleSet.avoidsRepeatedPairs {
            penalty += history.teammateCount(for: match.teamA.players) * 100
            penalty += history.teammateCount(for: match.teamB.players) * 100
        }
        if ruleSet.avoidsRepeatedOpponents {
            penalty += history.opponentCount(
                teamA: match.teamA.players,
                teamB: match.teamB.players
            ) * 25
        }
        return penalty
    }

    private func updateParticipantCounters(
        _ participants: [Participant],
        playingIDs: Set<UUID>,
        waitingIDs: Set<UUID>
    ) -> [Participant] {
        participants.map { participant in
            var updated = participant
            if playingIDs.contains(participant.id) {
                updated.playCount += 1
                updated.consecutivePlayCount += 1
                updated.consecutiveWaitCount = 0
            } else if waitingIDs.contains(participant.id) {
                updated.waitingCount += 1
                updated.consecutiveWaitCount += 1
                updated.consecutivePlayCount = 0
            }
            return updated
        }
    }
}

private struct MatchHistory {
    private var teammateCounts: [PlayerPair: Int]
    private var opponentCounts: [PlayerPair: Int]

    init(rounds: [Round]) {
        var teammateCounts: [PlayerPair: Int] = [:]
        var opponentCounts: [PlayerPair: Int] = [:]
        for match in rounds.flatMap(\.matches) {
            teammateCounts[PlayerPair(match.teamA.players), default: 0] += 1
            teammateCounts[PlayerPair(match.teamB.players), default: 0] += 1
            for teamAPlayer in match.teamA.players {
                for teamBPlayer in match.teamB.players {
                    opponentCounts[PlayerPair([teamAPlayer, teamBPlayer]), default: 0] += 1
                }
            }
        }
        self.teammateCounts = teammateCounts
        self.opponentCounts = opponentCounts
    }

    func teammateCount(for players: [Participant]) -> Int {
        teammateCounts[PlayerPair(players), default: 0]
    }

    func opponentCount(teamA: [Participant], teamB: [Participant]) -> Int {
        teamA.flatMap { teamAPlayer in
            teamB.map { teamBPlayer in
                PlayerPair([teamAPlayer, teamBPlayer])
            }
        }
        .map { opponentCounts[$0, default: 0] }
        .reduce(0, +)
    }
}

private struct PlayerPair: Hashable {
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

public enum RoundGenerationError: LocalizedError, Equatable, Sendable {
    case notEnoughParticipants

    public var errorDescription: String? {
        switch self {
        case .notEnoughParticipants:
            "参加可能な人が4人未満です。"
        }
    }
}

private extension [Participant] {
    func sortedForDisplay() -> [Participant] {
        sorted { lhs, rhs in
            lhs.displayName.localizedStandardCompare(rhs.displayName) == .orderedAscending
        }
    }

    func sortedForCourtAssignment() -> [Participant] {
        sorted { lhs, rhs in
            if lhs.skillLevel.rawValue == rhs.skillLevel.rawValue {
                return lhs.displayName.localizedStandardCompare(rhs.displayName) == .orderedAscending
            }
            return lhs.skillLevel.rawValue > rhs.skillLevel.rawValue
        }
    }
}
