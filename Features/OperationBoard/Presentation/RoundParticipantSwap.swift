import PickleBallMatchingCore

extension Round {
    var participantsInRound: [Participant] {
        matches.flatMap { match in
            match.teamA.players + match.teamB.players
        } + waitingParticipants
    }

    mutating func swapParticipants(firstID: Participant.ID, secondID: Participant.ID) -> Bool {
        guard firstID != secondID,
              let first = participantLocation(for: firstID),
              let second = participantLocation(for: secondID)
        else {
            return false
        }

        setParticipant(second.participant, at: first.slot)
        setParticipant(first.participant, at: second.slot)
        return true
    }

    private func participantLocation(for participantID: Participant.ID) -> RoundParticipantLocation? {
        for matchIndex in matches.indices {
            if let playerIndex = matches[matchIndex].teamA.players.firstIndex(where: { $0.id == participantID }) {
                return RoundParticipantLocation(
                    participant: matches[matchIndex].teamA.players[playerIndex],
                    slot: .teamA(matchIndex: matchIndex, playerIndex: playerIndex)
                )
            }
            if let playerIndex = matches[matchIndex].teamB.players.firstIndex(where: { $0.id == participantID }) {
                return RoundParticipantLocation(
                    participant: matches[matchIndex].teamB.players[playerIndex],
                    slot: .teamB(matchIndex: matchIndex, playerIndex: playerIndex)
                )
            }
        }

        if let waitingIndex = waitingParticipants.firstIndex(where: { $0.id == participantID }) {
            return RoundParticipantLocation(
                participant: waitingParticipants[waitingIndex],
                slot: .waiting(index: waitingIndex)
            )
        }

        return nil
    }

    private mutating func setParticipant(_ participant: Participant, at slot: RoundParticipantSlot) {
        switch slot {
        case let .teamA(matchIndex, playerIndex):
            matches[matchIndex].teamA.players[playerIndex] = participant
        case let .teamB(matchIndex, playerIndex):
            matches[matchIndex].teamB.players[playerIndex] = participant
        case let .waiting(index):
            waitingParticipants[index] = participant
        }
    }
}

private struct RoundParticipantLocation {
    var participant: Participant
    var slot: RoundParticipantSlot
}

private enum RoundParticipantSlot {
    case teamA(matchIndex: Int, playerIndex: Int)
    case teamB(matchIndex: Int, playerIndex: Int)
    case waiting(index: Int)
}
