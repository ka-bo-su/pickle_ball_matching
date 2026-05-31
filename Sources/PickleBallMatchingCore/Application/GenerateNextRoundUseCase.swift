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

        let matches = makeMatches(from: selectedParticipants, courtCount: playableCourtCount)
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

    private func makeMatches(from participants: [Participant], courtCount: Int) -> [Match] {
        (0 ..< courtCount).map { index in
            let startIndex = index * 4
            let group = Array(participants[startIndex ..< startIndex + 4])
                .sorted { lhs, rhs in
                    if lhs.skillLevel.rawValue == rhs.skillLevel.rawValue {
                        return lhs.displayName.localizedStandardCompare(rhs.displayName) == .orderedAscending
                    }
                    return lhs.skillLevel.rawValue > rhs.skillLevel.rawValue
                }
            let teamA = DoublesTeam(players: [group[0], group[3]])
            let teamB = DoublesTeam(players: [group[1], group[2]])
            return Match(courtNumber: index + 1, teamA: teamA, teamB: teamB)
        }
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
