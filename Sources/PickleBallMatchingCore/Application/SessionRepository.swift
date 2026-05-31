public protocol SessionRepository: Sendable {
    func loadLatestSession() throws -> Session?
    func save(_ session: Session) throws
}
