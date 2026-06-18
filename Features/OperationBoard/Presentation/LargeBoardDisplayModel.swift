enum LargeBoardTimingStatus: Equatable {
    case scheduled
    case inProgress
    case timeUp
    case finished
}

struct LargeBoardDisplayModel: Equatable {
    var sessionName: String
    var roundTitle: String
    var roundStatusTitle: String
    var remainingTimeText: String
    var timingDetailText: String
    var timingStatus: LargeBoardTimingStatus
    var announcement: String
    var courts: [LargeBoardCourtDisplay]
    var waitingPlayerNames: [String]
    var canStart: Bool
    var canFinish: Bool

    var waitingTitle: String {
        waitingPlayerNames.isEmpty ? "待機なし" : "待機者"
    }

    var waitingSummary: String {
        waitingPlayerNames.isEmpty ? "全員がコートに入っています" : waitingPlayerNames.joined(separator: "、")
    }

    var isTimeUp: Bool {
        timingStatus == .timeUp
    }

    var isFinished: Bool {
        timingStatus == .finished
    }

    var timingAccessibilityLabel: String {
        "\(roundStatusTitle)、残り時間 \(remainingTimeText)、\(timingDetailText)"
    }
}

struct LargeBoardCourtDisplay: Equatable, Identifiable {
    var courtNumber: Int
    var teamAPlayerNames: [String]
    var teamBPlayerNames: [String]

    var id: Int {
        courtNumber
    }

    var courtTitle: String {
        "コート\(courtNumber)"
    }

    var accessibilityLabel: String {
        "\(courtTitle)、チームA \(teamAPlayerNames.joined(separator: "、"))、チームB \(teamBPlayerNames.joined(separator: "、"))"
    }
}
