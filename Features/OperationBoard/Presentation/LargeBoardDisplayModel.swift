struct LargeBoardDisplayModel: Equatable {
    var sessionName: String
    var roundTitle: String
    var announcement: String
    var courts: [LargeBoardCourtDisplay]
    var waitingPlayerNames: [String]

    var waitingTitle: String {
        waitingPlayerNames.isEmpty ? "待機なし" : "待機者"
    }

    var waitingSummary: String {
        waitingPlayerNames.isEmpty ? "全員がコートに入っています" : waitingPlayerNames.joined(separator: "、")
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
