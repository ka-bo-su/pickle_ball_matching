import Foundation

public struct AddParticipantFromProfileUseCase: Sendable {
    public init() {}

    public func execute(
        session: Session,
        profile: MemberProfile
    ) throws -> Session {
        guard !session.participants.contains(where: { $0.id == profile.id }) else {
            throw AddParticipantError.alreadyExists
        }
        var updatedSession = session
        updatedSession.participants.append(profile.toParticipant())
        updatedSession.updatedAt = Date()
        return updatedSession
    }
}

public enum AddParticipantError: LocalizedError, Equatable, Sendable {
    case alreadyExists

    public var errorDescription: String? {
        switch self {
        case .alreadyExists:
            "この参加者はすでに追加されています。"
        }
    }
}
