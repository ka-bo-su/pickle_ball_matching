import Foundation

public struct PlayerProfile: Equatable, Identifiable, Sendable {
    public let id: UUID
    public let displayName: String
    public let skillLevel: SkillLevel
    public let preferredPlayStyle: PlayStyle
    public let locationName: String

    public init(
        id: UUID = UUID(),
        displayName: String,
        skillLevel: SkillLevel,
        preferredPlayStyle: PlayStyle,
        locationName: String
    ) {
        self.id = id
        self.displayName = displayName
        self.skillLevel = skillLevel
        self.preferredPlayStyle = preferredPlayStyle
        self.locationName = locationName
    }
}

public enum SkillLevel: String, CaseIterable, Sendable {
    case beginner
    case recreational
    case competitive

    public var displayName: String {
        switch self {
        case .beginner:
            "Beginner"
        case .recreational:
            "Recreational"
        case .competitive:
            "Competitive"
        }
    }
}

public enum PlayStyle: String, CaseIterable, Sendable {
    case casual
    case drillFocused
    case tournamentPrep

    public var displayName: String {
        switch self {
        case .casual:
            "Casual"
        case .drillFocused:
            "Drill focused"
        case .tournamentPrep:
            "Tournament prep"
        }
    }
}
