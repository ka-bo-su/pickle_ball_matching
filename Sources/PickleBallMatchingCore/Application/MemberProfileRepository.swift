public protocol MemberProfileRepository: Sendable {
    func loadProfile() throws -> MemberProfile?
    func save(_ profile: MemberProfile) throws
}
