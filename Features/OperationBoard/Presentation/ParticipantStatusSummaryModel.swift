import PickleBallMatchingCore

struct ParticipantStatusSummaryModel: Equatable {
    var headline: String
    var detail: String

    var accessibilityLabel: String {
        "\(headline)、\(detail)"
    }
}

extension ParticipantStatusSummaryModel {
    init(participants: [Participant]) {
        let registeredCount = participants.count
        let availableCount = participants.count(where: { $0.status.isAvailableForRound })
        let statusDetails = ParticipantStatus.allCases
            .filter { $0 != .active }
            .compactMap { status -> String? in
                let count = participants.count(where: { $0.status == status })
                guard count > 0 else {
                    return nil
                }

                return "\(status.displayName) \(count)人"
            }

        headline = "登録 \(registeredCount)人・参加可能 \(availableCount)人"
        detail = statusDetails.isEmpty ? "全員参加可能です" : statusDetails.joined(separator: "、")
    }
}
