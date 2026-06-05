import PickleBallMatchingCore

struct OperationBoardSummaryModel: Equatable {
    var statusTitle: String
    var statusDetail: String
    var participantSummary: String
    var courtSummary: String
    var waitingSummary: String
    var proPlanNotice: String?
    var nextActionTitle: String
    var nextActionDetail: String

    var accessibilityLabel: String {
        [
            statusTitle,
            statusDetail,
            participantSummary,
            courtSummary,
            waitingSummary,
            proPlanNotice,
            nextActionTitle,
            nextActionDetail
        ]
        .compactMap(\.self)
        .filter { !$0.isEmpty }
        .joined(separator: "、")
    }
}

extension OperationBoardViewModel {
    var boardSummaryModel: OperationBoardSummaryModel {
        let availableCount = session.participants.count(where: { $0.status.isAvailableForRound })
        let registeredCount = session.participants.count
        let participantSummary = "参加可能 \(availableCount)人 / 登録 \(registeredCount)人"
        let playableCourtCount = availableCount >= 4
            ? max(1, min(session.courtCount, availableCount / 4))
            : 0
        let expectedWaitingCount = max(0, availableCount - playableCourtCount * 4)
        let proPlanNotice = makeProPlanNotice(
            registeredCount: registeredCount,
            courtCount: session.courtCount
        )
        let courtSummary = playableCourtCount > 0
            ? "設定 \(session.courtCount)面・使用予定 \(playableCourtCount)面・\(session.roundDurationMinutes)分"
            : "設定 \(session.courtCount)面・\(session.roundDurationMinutes)分"

        guard let currentRound else {
            if canGenerateRound {
                let extraPlayersForAllCourts = max(0, session.courtCount * 4 - availableCount)
                let courtAdjustment = extraPlayersForAllCourts > 0 && playableCourtCount < session.courtCount
                    ? "全\(session.courtCount)面を使うには、あと\(extraPlayersForAllCourts)人必要です。"
                    : "設定したコート数で進行できます。"
                return OperationBoardSummaryModel(
                    statusTitle: "最初のラウンドを作れます",
                    statusDetail: "\(playableCourtCount)面で\(playableCourtCount * 4)人がプレー予定です",
                    participantSummary: participantSummary,
                    courtSummary: courtSummary,
                    waitingSummary: expectedWaitingCount == 0
                        ? "生成後の待機見込みなし"
                        : "生成後の待機見込み \(expectedWaitingCount)人",
                    proPlanNotice: proPlanNotice,
                    nextActionTitle: "次の操作",
                    nextActionDetail: "\(courtAdjustment) 次ラウンド生成を押すと、各コートの対戦カードと待機者を作成します。"
                )
            }

            if registeredCount == 0 {
                return OperationBoardSummaryModel(
                    statusTitle: "今日の参加者を登録します",
                    statusDetail: "最初のラウンド生成には参加可能な人が4人必要です",
                    participantSummary: participantSummary,
                    courtSummary: courtSummary,
                    waitingSummary: "まだ待機者はありません",
                    proPlanNotice: proPlanNotice,
                    nextActionTitle: "次の操作",
                    nextActionDetail: "参加者欄で名前を追加します。4人以上になると次ラウンド生成を押せます。"
                )
            }

            let missingCount = max(0, 4 - availableCount)
            return OperationBoardSummaryModel(
                statusTitle: "参加者を準備中",
                statusDetail: "参加可能な人があと\(missingCount)人必要です",
                participantSummary: participantSummary,
                courtSummary: courtSummary,
                waitingSummary: "ラウンド生成には4人以上必要です",
                proPlanNotice: proPlanNotice,
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
            proPlanNotice: proPlanNotice,
            nextActionTitle: "次の操作",
            nextActionDetail: "必要なら入れ替えを行い、終了後に次ラウンド生成で次の組み合わせへ進みます。"
        )
    }

    private func makeProPlanNotice(registeredCount: Int, courtCount: Int) -> String? {
        guard registeredCount > 8 || courtCount > 1 else {
            return nil
        }

        return "無料版目安（8人 / 1面）を超えています。Pro候補の運営です。"
    }
}
