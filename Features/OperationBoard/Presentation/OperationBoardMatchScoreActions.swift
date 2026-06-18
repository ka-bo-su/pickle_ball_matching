import PickleBallMatchingCore

extension OperationBoardViewModel {
    func score(for matchID: Match.ID) -> MatchScore {
        currentRound?.matches.first(where: { $0.id == matchID })?.score
            ?? MatchScore(teamAScore: 0, teamBScore: 0)
    }

    func winnerText(for matchID: Match.ID) -> String {
        currentRound?.matches.first(where: { $0.id == matchID })?.winner.displayName
            ?? MatchWinner.notRecorded.displayName
    }

    func updateCurrentRoundMatchScore(
        matchID: Match.ID,
        teamAScore: Int,
        teamBScore: Int
    ) {
        guard let currentRoundIndex,
              let matchIndex = session.rounds[currentRoundIndex].matches.firstIndex(where: { $0.id == matchID })
        else {
            return
        }

        let newScore = MatchScore(teamAScore: teamAScore, teamBScore: teamBScore)
        guard session.rounds[currentRoundIndex].matches[matchIndex].score != newScore else {
            return
        }

        session.rounds[currentRoundIndex].matches[matchIndex].score = newScore
        persistSessionMutation()
    }

    private var currentRoundIndex: Int? {
        guard !session.rounds.isEmpty else {
            return nil
        }

        return session.rounds.index(before: session.rounds.endIndex)
    }
}
