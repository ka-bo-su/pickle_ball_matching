import Foundation

public struct Round: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public var number: Int
    public var matches: [Match]
    public var waitingParticipants: [Participant]
    public var startedAt: Date?
    public var finishedAt: Date?
    public var createdAt: Date
    public var isConfirmed: Bool

    public init(
        id: UUID = UUID(),
        number: Int,
        matches: [Match],
        waitingParticipants: [Participant],
        startedAt: Date? = nil,
        finishedAt: Date? = nil,
        createdAt: Date = Date(),
        isConfirmed: Bool = false
    ) {
        self.id = id
        self.number = number
        self.matches = matches
        self.waitingParticipants = waitingParticipants
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.createdAt = createdAt
        self.isConfirmed = isConfirmed
    }

    public var status: RoundStatus {
        if finishedAt != nil {
            return .finished
        }
        if startedAt != nil {
            return .inProgress
        }
        return .scheduled
    }

    public func remainingSeconds(durationMinutes: Int, now: Date) -> Int {
        let totalSeconds = max(1, durationMinutes) * 60
        guard finishedAt == nil else {
            return 0
        }
        guard let startedAt else {
            return totalSeconds
        }

        let elapsedSeconds = max(0, Int(now.timeIntervalSince(startedAt)))
        return max(0, totalSeconds - elapsedSeconds)
    }
}

public enum RoundStatus: String, Codable, Sendable {
    case scheduled
    case inProgress
    case finished

    public var displayName: String {
        switch self {
        case .scheduled:
            "未開始"
        case .inProgress:
            "進行中"
        case .finished:
            "終了"
        }
    }
}

public struct Match: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public var courtNumber: Int
    public var teamA: DoublesTeam
    public var teamB: DoublesTeam
    public var status: MatchStatus
    public var score: MatchScore?

    public init(
        id: UUID = UUID(),
        courtNumber: Int,
        teamA: DoublesTeam,
        teamB: DoublesTeam,
        status: MatchStatus = .scheduled,
        score: MatchScore? = nil
    ) {
        self.id = id
        self.courtNumber = courtNumber
        self.teamA = teamA
        self.teamB = teamB
        self.status = status
        self.score = score
    }

    public var winner: MatchWinner {
        score?.winner ?? .notRecorded
    }
}

public struct DoublesTeam: Codable, Equatable, Sendable {
    public var players: [Participant]

    public init(players: [Participant]) {
        self.players = players
    }

    public var skillTotal: Int {
        players.map(\.skillLevel.rawValue).reduce(0, +)
    }
}

public enum MatchStatus: String, Codable, Sendable {
    case scheduled
    case inProgress
    case finished

    public var displayName: String {
        switch self {
        case .scheduled:
            "予定"
        case .inProgress:
            "進行中"
        case .finished:
            "終了"
        }
    }
}

public struct MatchScore: Codable, Equatable, Sendable {
    public var teamAScore: Int
    public var teamBScore: Int

    public init(teamAScore: Int, teamBScore: Int) {
        self.teamAScore = max(0, teamAScore)
        self.teamBScore = max(0, teamBScore)
    }

    public var winner: MatchWinner {
        if teamAScore > teamBScore {
            return .teamA
        }
        if teamBScore > teamAScore {
            return .teamB
        }
        return .draw
    }
}

public enum MatchWinner: String, Codable, Sendable {
    case notRecorded
    case teamA
    case teamB
    case draw

    public var displayName: String {
        switch self {
        case .notRecorded:
            "未記録"
        case .teamA:
            "チームA勝利"
        case .teamB:
            "チームB勝利"
        case .draw:
            "引き分け"
        }
    }
}
