import PickleBallMatchingCore

struct OperationBoardSummaryModel: Equatable {
    var statusTitle: String
    var statusDetail: String
    var participantSummary: String
    var courtSummary: String
    var waitingSummary: String
    var nextActionTitle: String
    var nextActionDetail: String

    var accessibilityLabel: String {
        [
            statusTitle,
            statusDetail,
            participantSummary,
            courtSummary,
            waitingSummary,
            nextActionTitle,
            nextActionDetail
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "、")
    }
}

extension OperationBoardViewModel {
    var boardSummaryModel: OperationBoardSummaryModel {
        let availableCount = session.participants.count(where: { $0.status.isAvailableForRound })
        let registeredCount = session.participants.count
        let participantSummary = "参加可能 \(availableCount)人 / 登録 \(registeredCount)人"
        let courtSummary = "設定 \(session.courtCount)面・\(session.roundDurationMinutes)分"

        guard let currentRound else {
            if canGenerateRound {
                return OperationBoardSummaryModel(
                    statusTitle: "最初のラウンドを作れます",
                    statusDetail: "準備できています",
                    participantSummary: participantSummary,
                    courtSummary: courtSummary,
                    waitingSummary: "まだ待機者は未定です",
                    nextActionTitle: "次の操作",
                    nextActionDetail: "次ラウンド生成を押すと、各コートの対戦カードと待機者を作成します。"
                )
            }

            let missingCount = max(0, 4 - availableCount)
            return OperationBoardSummaryModel(
                statusTitle: "参加者を準備中",
                statusDetail: "参加可能な人があと\(missingCount)人必要です",
                participantSummary: participantSummary,
                courtSummary: courtSummary,
                waitingSummary: "ラウンド生成には4人以上必要です",
                nextActionTitle: "次の操作",
                nextActionDetail: "参加者を追加するか、状態を参加中または代替参加に変更します。"
            )
        }

        let waitingCount = currentRound.waitingParticipants.count
        return OperationBoardSummaryModel(
            statusTitle: "現在 ラウンド\(currentRound.number)",
            statusDetail: "\(currentRound.matches.count)面で進行中",
            participantSummary: participantSummary,
            courtSummary: courtSummary,
            waitingSummary: waitingCount == 0 ? "待機なし" : "待機 \(waitingCount)人",
            nextActionTitle: "次の操作",
            nextActionDetail: "必要なら入れ替えを行い、終了後に次ラウンド生成で次の組み合わせへ進みます。"
        )
    }
}
