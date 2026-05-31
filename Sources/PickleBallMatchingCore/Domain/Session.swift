import Foundation

public struct Session: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var date: Date
    public var courtCount: Int
    public var roundDurationMinutes: Int
    public var mode: OperationMode
    public var participants: [Participant]
    public var ruleSet: SessionRuleSet
    public var rounds: [Round]
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        date: Date = Date(),
        courtCount: Int = 1,
        roundDurationMinutes: Int = 12,
        mode: OperationMode = .normalPractice,
        participants: [Participant] = [],
        ruleSet: SessionRuleSet = .balancedPractice,
        rounds: [Round] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.courtCount = max(1, courtCount)
        self.roundDurationMinutes = max(1, roundDurationMinutes)
        self.mode = mode
        self.participants = participants
        self.ruleSet = ruleSet
        self.rounds = rounds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public var currentRound: Round? {
        rounds.last
    }
}

public enum OperationMode: String, CaseIterable, Codable, Sendable {
    case normalPractice
    case beginnerSession
    case levelBalanced
    case socialMix

    public var displayName: String {
        switch self {
        case .normalPractice:
            "通常練習"
        case .beginnerSession:
            "初心者会"
        case .levelBalanced:
            "レベル均等"
        case .socialMix:
            "交流重視"
        }
    }
}

public struct SessionRuleSet: Codable, Equatable, Sendable {
    public var balancesWaitingCount: Bool
    public var avoidsConsecutiveWaiting: Bool
    public var avoidsRepeatedPairs: Bool
    public var reducesLevelGap: Bool
    public var protectsBeginners: Bool

    public init(
        balancesWaitingCount: Bool = true,
        avoidsConsecutiveWaiting: Bool = true,
        avoidsRepeatedPairs: Bool = true,
        reducesLevelGap: Bool = true,
        protectsBeginners: Bool = true
    ) {
        self.balancesWaitingCount = balancesWaitingCount
        self.avoidsConsecutiveWaiting = avoidsConsecutiveWaiting
        self.avoidsRepeatedPairs = avoidsRepeatedPairs
        self.reducesLevelGap = reducesLevelGap
        self.protectsBeginners = protectsBeginners
    }

    public static let balancedPractice = SessionRuleSet()
}
