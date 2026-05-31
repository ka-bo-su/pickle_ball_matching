public protocol MatchingRepository: Sendable {
    func fetchCandidates(for profile: PlayerProfile) async throws -> [MatchCandidate]
}
