import Foundation

public struct MatchCandidate: Equatable, Identifiable, Sendable {
    public let id: UUID
    public let player: PlayerProfile
    public let compatibilityScore: Int
    public let reason: String

    public init(
        id: UUID = UUID(),
        player: PlayerProfile,
        compatibilityScore: Int,
        reason: String
    ) {
        self.id = id
        self.player = player
        self.compatibilityScore = max(0, min(100, compatibilityScore))
        self.reason = reason
    }
}
