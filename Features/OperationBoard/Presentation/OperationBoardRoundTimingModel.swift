import Foundation
import PickleBallMatchingCore

struct OperationBoardRoundTimingModel: Equatable {
    var statusTitle: String
    var remainingTimeText: String
    var detailText: String
    var canStart: Bool
    var canFinish: Bool

    init(round: Round, durationMinutes: Int, now: Date) {
        let remainingSeconds = round.remainingSeconds(durationMinutes: durationMinutes, now: now)
        remainingTimeText = Self.format(seconds: remainingSeconds)
        canStart = round.status == .scheduled
        canFinish = round.status == .inProgress

        switch round.status {
        case .scheduled:
            statusTitle = "未開始"
            detailText = "試合開始を押すと残り時間のカウントを始めます。"
        case .inProgress where remainingSeconds == 0:
            statusTitle = "時間です"
            detailText = "ラウンド終了を押して次の組み合わせ準備へ進みます。"
        case .inProgress:
            statusTitle = "進行中"
            detailText = "試合中です。終了したらラウンド終了を押します。"
        case .finished:
            statusTitle = "終了"
            detailText = "次ラウンド生成で次の組み合わせへ進みます。"
        }
    }

    var accessibilityLabel: String {
        "\(statusTitle)、残り時間 \(remainingTimeText)、\(detailText)"
    }

    private static func format(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
