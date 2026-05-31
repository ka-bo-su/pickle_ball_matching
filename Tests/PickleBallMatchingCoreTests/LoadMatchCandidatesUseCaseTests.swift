@testable import PickleBallMatchingCore
import XCTest

final class LoadMatchCandidatesUseCaseTests: XCTestCase {
    func testExecuteSortsCandidatesByCompatibilityScoreDescending() async throws {
        let profile = PlayerProfile(
            displayName: "Current Player",
            skillLevel: .recreational,
            preferredPlayStyle: .casual,
            locationName: "Tokyo"
        )
        let repository = StubMatchingRepository(candidates: [
            MatchCandidate(
                player: PlayerProfile(
                    displayName: "Low",
                    skillLevel: .beginner,
                    preferredPlayStyle: .drillFocused,
                    locationName: "Osaka"
                ),
                compatibilityScore: 10,
                reason: "low"
            ),
            MatchCandidate(
                player: PlayerProfile(
                    displayName: "High",
                    skillLevel: .recreational,
                    preferredPlayStyle: .casual,
                    locationName: "Tokyo"
                ),
                compatibilityScore: 90,
                reason: "high"
            ),
        ])
        let useCase = LoadMatchCandidatesUseCase(repository: repository)

        let result = try await useCase.execute(for: profile)

        XCTAssertEqual(result.map(\.compatibilityScore), [90, 10])
    }

    func testInMemoryRepositoryExcludesCurrentPlayer() async throws {
        let current = PlayerProfile(
            displayName: "Current",
            skillLevel: .beginner,
            preferredPlayStyle: .casual,
            locationName: "Tokyo"
        )
        let repository = InMemoryMatchingRepository(candidates: [
            current,
            PlayerProfile(
                displayName: "Candidate",
                skillLevel: .beginner,
                preferredPlayStyle: .casual,
                locationName: "Tokyo"
            ),
        ])

        let result = try await repository.fetchCandidates(for: current)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].player.displayName, "Candidate")
    }
}

private struct StubMatchingRepository: MatchingRepository {
    let candidates: [MatchCandidate]

    func fetchCandidates(for _: PlayerProfile) async throws -> [MatchCandidate] {
        candidates
    }
}
