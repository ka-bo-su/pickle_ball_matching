public protocol SessionRepository: Sendable {
    func loadLatestSession() throws -> Session?
    func loadSavedSessions() throws -> [Session]
    func save(_ session: Session) throws
    func deleteSavedSession(id: Session.ID) throws
}

public extension SessionRepository {
    func loadSavedSessions() throws -> [Session] {
        guard let latestSession = try loadLatestSession() else {
            return []
        }
        return [latestSession]
    }

    func deleteSavedSession(id: Session.ID) throws {}
}
