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
    public var avoidsRepeatedOpponents: Bool
    public var reducesLevelGap: Bool
    public var protectsBeginners: Bool

    public init(
        balancesWaitingCount: Bool = true,
        avoidsConsecutiveWaiting: Bool = true,
        avoidsRepeatedPairs: Bool = true,
        avoidsRepeatedOpponents: Bool = true,
        reducesLevelGap: Bool = true,
        protectsBeginners: Bool = true
    ) {
        self.balancesWaitingCount = balancesWaitingCount
        self.avoidsConsecutiveWaiting = avoidsConsecutiveWaiting
        self.avoidsRepeatedPairs = avoidsRepeatedPairs
        self.avoidsRepeatedOpponents = avoidsRepeatedOpponents
        self.reducesLevelGap = reducesLevelGap
        self.protectsBeginners = protectsBeginners
    }

    public static let balancedPractice = SessionRuleSet()

    private enum CodingKeys: String, CodingKey {
        case balancesWaitingCount
        case avoidsConsecutiveWaiting
        case avoidsRepeatedPairs
        case avoidsRepeatedOpponents
        case reducesLevelGap
        case protectsBeginners
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        balancesWaitingCount = try container.decodeIfPresent(
            Bool.self,
            forKey: .balancesWaitingCount
        ) ?? true
        avoidsConsecutiveWaiting = try container.decodeIfPresent(
            Bool.self,
            forKey: .avoidsConsecutiveWaiting
        ) ?? true
        avoidsRepeatedPairs = try container.decodeIfPresent(
            Bool.self,
            forKey: .avoidsRepeatedPairs
        ) ?? true
        avoidsRepeatedOpponents = try container.decodeIfPresent(
            Bool.self,
            forKey: .avoidsRepeatedOpponents
        ) ?? true
        reducesLevelGap = try container.decodeIfPresent(
            Bool.self,
            forKey: .reducesLevelGap
        ) ?? true
        protectsBeginners = try container.decodeIfPresent(
            Bool.self,
            forKey: .protectsBeginners
        ) ?? true
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(balancesWaitingCount, forKey: .balancesWaitingCount)
        try container.encode(avoidsConsecutiveWaiting, forKey: .avoidsConsecutiveWaiting)
        try container.encode(avoidsRepeatedPairs, forKey: .avoidsRepeatedPairs)
        try container.encode(avoidsRepeatedOpponents, forKey: .avoidsRepeatedOpponents)
        try container.encode(reducesLevelGap, forKey: .reducesLevelGap)
        try container.encode(protectsBeginners, forKey: .protectsBeginners)
    }
}
