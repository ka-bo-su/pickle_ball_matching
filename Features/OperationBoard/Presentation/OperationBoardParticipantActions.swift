import PickleBallMatchingCore

@MainActor
extension OperationBoardViewModel {
    func removeParticipant(participantID: Participant.ID) {
        guard let index = session.participants.firstIndex(where: { $0.id == participantID }) else {
            return
        }

        session.participants.remove(at: index)
        clearUndoHistory()
        persistSessionMutation()
    }

    func toggleParticipantAttendance(participantID: Participant.ID) {
        guard let index = session.participants.firstIndex(where: { $0.id == participantID }) else {
            return
        }

        session.participants[index].status = session.participants[index].status.isAvailableForRound ? .absent : .active
        clearUndoHistory()
        persistSessionMutation()
    }
}
