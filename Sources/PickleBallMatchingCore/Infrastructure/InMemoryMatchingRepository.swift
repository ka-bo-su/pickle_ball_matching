import Foundation

public struct InMemoryMatchingRepository: MatchingRepository {
    private let candidates: [PlayerProfile]

    public init(candidates: [PlayerProfile] = InMemoryMatchingRepository.defaultCandidates) {
        self.candidates = candidates
    }

    public func fetchCandidates(for profile: PlayerProfile) async throws -> [MatchCandidate] {
        candidates
            .filter { $0.id != profile.id }
            .map { candidate in
                let skillBonus = candidate.skillLevel == profile.skillLevel ? 35 : 15
                let styleBonus = candidate.preferredPlayStyle == profile.preferredPlayStyle ? 35 : 15
                let locationBonus = candidate.locationName == profile.locationName ? 20 : 10
                let score = skillBonus + styleBonus + locationBonus
                return MatchCandidate(
                    player: candidate,
                    compatibilityScore: score,
                    reason: [
                        candidate.skillLevel.displayName,
                        candidate.preferredPlayStyle.displayName,
                        candidate.locationName
                    ].joined(separator: ", ")
                )
            }
    }

    public static let defaultCandidates: [PlayerProfile] = [
        PlayerProfile(
            displayName: "Aoi Tanaka",
            skillLevel: .recreational,
            preferredPlayStyle: .casual,
            locationName: "Tokyo"
        ),
        PlayerProfile(
            displayName: "Ren Sato",
            skillLevel: .competitive,
            preferredPlayStyle: .tournamentPrep,
            locationName: "Yokohama"
        ),
        PlayerProfile(
            displayName: "Mio Suzuki",
            skillLevel: .beginner,
            preferredPlayStyle: .drillFocused,
            locationName: "Tokyo"
        )
    ]
}
