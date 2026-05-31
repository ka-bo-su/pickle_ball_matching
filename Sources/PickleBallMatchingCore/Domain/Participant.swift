import Foundation

public struct Participant: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public var displayName: String
    public var phoneticName: String?
    public var skillLevel: SkillLevel
    public var gender: Gender?
    public var ageGroup: AgeGroup?
    public var memo: String
    public var status: ParticipantStatus
    public var fixedPairID: UUID?
    public var playCount: Int
    public var waitingCount: Int
    public var consecutivePlayCount: Int
    public var consecutiveWaitCount: Int

    public init(
        id: UUID = UUID(),
        displayName: String,
        phoneticName: String? = nil,
        skillLevel: SkillLevel = .beginner,
        gender: Gender? = nil,
        ageGroup: AgeGroup? = nil,
        memo: String = "",
        status: ParticipantStatus = .active,
        fixedPairID: UUID? = nil,
        playCount: Int = 0,
        waitingCount: Int = 0,
        consecutivePlayCount: Int = 0,
        consecutiveWaitCount: Int = 0
    ) {
        self.id = id
        self.displayName = displayName
        self.phoneticName = phoneticName
        self.skillLevel = skillLevel
        self.gender = gender
        self.ageGroup = ageGroup
        self.memo = memo
        self.status = status
        self.fixedPairID = fixedPairID
        self.playCount = playCount
        self.waitingCount = waitingCount
        self.consecutivePlayCount = consecutivePlayCount
        self.consecutiveWaitCount = consecutiveWaitCount
    }
}

public enum ParticipantStatus: String, CaseIterable, Codable, Sendable {
    case active
    case late
    case wantsBreak
    case leavingEarly
    case absent
    case substitute
    case observing

    public var isAvailableForRound: Bool {
        switch self {
        case .active, .leavingEarly, .substitute:
            true
        case .late, .wantsBreak, .absent, .observing:
            false
        }
    }

    public var displayName: String {
        switch self {
        case .active:
            "参加中"
        case .late:
            "遅刻"
        case .wantsBreak:
            "休憩希望"
        case .leavingEarly:
            "途中退出予定"
        case .absent:
            "欠席"
        case .substitute:
            "代替参加"
        case .observing:
            "見学"
        }
    }
}

public enum SkillLevel: Int, CaseIterable, Codable, Sendable {
    case beginner = 1
    case novice = 2
    case intermediate = 3
    case advanced = 4

    public var displayName: String {
        switch self {
        case .beginner:
            "初心者"
        case .novice:
            "初級"
        case .intermediate:
            "中級"
        case .advanced:
            "上級"
        }
    }
}

public enum Gender: String, CaseIterable, Codable, Sendable {
    case female
    case male
    case notSpecified

    public var displayName: String {
        switch self {
        case .female:
            "女性"
        case .male:
            "男性"
        case .notSpecified:
            "未設定"
        }
    }
}

public enum AgeGroup: String, CaseIterable, Codable, Sendable {
    case under18
    case twenties
    case thirties
    case forties
    case fifties
    case sixtiesAndOver
    case notSpecified

    public var displayName: String {
        switch self {
        case .under18:
            "18歳未満"
        case .twenties:
            "20代"
        case .thirties:
            "30代"
        case .forties:
            "40代"
        case .fifties:
            "50代"
        case .sixtiesAndOver:
            "60代以上"
        case .notSpecified:
            "未設定"
        }
    }
}
