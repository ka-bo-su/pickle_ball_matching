import Foundation
import PickleBallMatchingCore

extension OperationBoardViewModel {
    func startCurrentRound(at startedAt: Date = Date()) {
        guard let currentRoundIndex,
              session.rounds[currentRoundIndex].status == .scheduled
        else {
            return
        }

        session.rounds[currentRoundIndex].startedAt = startedAt
        session.rounds[currentRoundIndex].matches = session.rounds[currentRoundIndex].matches.map { match in
            var match = match
            match.status = .inProgress
            return match
        }
        persistSessionMutation()
    }

    func finishCurrentRound(at finishedAt: Date = Date()) {
        guard let currentRoundIndex,
              session.rounds[currentRoundIndex].status != .finished
        else {
            return
        }

        if session.rounds[currentRoundIndex].startedAt == nil {
            session.rounds[currentRoundIndex].startedAt = finishedAt
        }
        session.rounds[currentRoundIndex].finishedAt = finishedAt
        session.rounds[currentRoundIndex].matches = session.rounds[currentRoundIndex].matches.map { match in
            var match = match
            match.status = .finished
            return match
        }
        persistSessionMutation()
    }

    func currentRoundTimingModel(now: Date = Date()) -> OperationBoardRoundTimingModel? {
        guard let currentRound else {
            return nil
        }

        return OperationBoardRoundTimingModel(
            round: currentRound,
            durationMinutes: session.roundDurationMinutes,
            now: now
        )
    }

    private var currentRoundIndex: Int? {
        guard !session.rounds.isEmpty else {
            return nil
        }

        return session.rounds.index(before: session.rounds.endIndex)
    }
}
