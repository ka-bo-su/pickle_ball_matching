public struct LoadMatchCandidatesUseCase: Sendable {
    private let repository: MatchingRepository

    public init(repository: MatchingRepository) {
        self.repository = repository
    }

    public func execute(for profile: PlayerProfile) async throws -> [MatchCandidate] {
        try await repository.fetchCandidates(for: profile)
            .sorted { $0.compatibilityScore > $1.compatibilityScore }
    }
}
