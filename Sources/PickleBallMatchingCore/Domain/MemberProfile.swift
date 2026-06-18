import Foundation

public struct MemberProfile: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public var displayName: String
    public var phoneticName: String?
    public var skillLevel: SkillLevel
    public var gender: Gender?
    public var ageGroup: AgeGroup?
    public var memo: String

    public init(
        id: UUID = UUID(),
        displayName: String,
        phoneticName: String? = nil,
        skillLevel: SkillLevel = .beginner,
        gender: Gender? = nil,
        ageGroup: AgeGroup? = nil,
        memo: String = ""
    ) {
        self.id = id
        self.displayName = displayName
        self.phoneticName = phoneticName
        self.skillLevel = skillLevel
        self.gender = gender
        self.ageGroup = ageGroup
        self.memo = memo
    }

    public func toParticipant(status: ParticipantStatus = .active) -> Participant {
        Participant(
            id: id,
            displayName: displayName,
            phoneticName: phoneticName,
            skillLevel: skillLevel,
            gender: gender,
            ageGroup: ageGroup,
            memo: memo,
            status: status
        )
    }
}
