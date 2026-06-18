import PickleBallMatchingCore

struct ParticipantSetupGuideModel: Equatable {
    var title: String
    var detail: String
    var systemImage: String

    var accessibilityLabel: String {
        [title, detail]
            .filter { !$0.isEmpty }
            .joined(separator: "、")
    }

    init(participants: [Participant], courtCount: Int) {
        let availableCount = participants.count(where: { $0.status.isAvailableForRound })

        if participants.isEmpty {
            title = "まず参加者を追加"
            detail = "下の入力欄に名前を入れて、最低4人を登録すると最初のラウンドを作れます。"
            systemImage = "person.badge.plus"
            return
        }

        if availableCount < 4 {
            let missingCount = 4 - availableCount
            title = "あと\(missingCount)人で生成可能"
            detail = "欠席や休憩希望の人は使われません。参加中または代替参加を4人以上にします。"
            systemImage = "person.crop.circle.badge.exclamationmark"
            return
        }

        let playableCourtCount = max(1, min(courtCount, availableCount / 4))
        let waitingCount = max(0, availableCount - playableCourtCount * 4)

        title = "ラウンド生成の準備完了"
        detail = waitingCount == 0
            ? "\(playableCourtCount)面で全員が入れます。次ラウンド生成を押します。"
            : "\(playableCourtCount)面で進行し、待機は\(waitingCount)人の見込みです。"
        systemImage = "checkmark.circle"
    }
}
