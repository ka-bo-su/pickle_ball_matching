import Foundation
import PickleBallMatchingCore

struct RoundHistoryDisplayModel: Equatable {
    var rounds: [RoundHistoryRoundDisplay]

    init(session: Session) {
        rounds = session.rounds
            .sorted { lhs, rhs in
                lhs.number > rhs.number
            }
            .map(RoundHistoryRoundDisplay.init(round:))
    }

    var isEmpty: Bool {
        rounds.isEmpty
    }
}

struct RoundHistoryRoundDisplay: Equatable, Identifiable {
    let id: Round.ID
    let title: String
    let statusText: String
    let waitingSummary: String
    let matches: [RoundHistoryMatchDisplay]

    init(round: Round) {
        id = round.id
        title = "ラウンド\(round.number)"
        statusText = round.status.displayName
        waitingSummary = round.waitingParticipants.isEmpty
            ? "待機なし"
            : "待機: \(round.waitingParticipants.map(\.displayName).joined(separator: "、"))"
        matches = round.matches.map(RoundHistoryMatchDisplay.init(match:))
    }

    var accessibilityLabel: String {
        let matchSummary = matches.map(\.accessibilityLabel).joined(separator: "。")
        return "\(title)、状態 \(statusText)、\(waitingSummary)。\(matchSummary)"
    }
}

struct RoundHistoryMatchDisplay: Equatable, Identifiable {
    let id: Match.ID
    let courtTitle: String
    let teamASummary: String
    let teamBSummary: String
    let scoreSummary: String
    let winnerSummary: String

    init(match: Match) {
        id = match.id
        courtTitle = "コート\(match.courtNumber)"
        teamASummary = "A: \(match.teamA.players.map(\.displayName).joined(separator: "・"))"
        teamBSummary = "B: \(match.teamB.players.map(\.displayName).joined(separator: "・"))"

        if let score = match.score {
            scoreSummary = "スコア A \(score.teamAScore) - B \(score.teamBScore)"
        } else {
            scoreSummary = "スコア未記録"
        }

        winnerSummary = match.winner.displayName
    }

    var accessibilityLabel: String {
        "\(courtTitle)、\(teamASummary)、\(teamBSummary)、\(scoreSummary)、結果 \(winnerSummary)"
    }
}
