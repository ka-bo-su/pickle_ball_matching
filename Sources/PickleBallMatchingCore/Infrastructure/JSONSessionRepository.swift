import Foundation

public struct JSONSessionRepository: SessionRepository {
    private let fileURL: URL
    private var historyDirectoryURL: URL {
        fileURL.deletingLastPathComponent().appendingPathComponent("sessions", isDirectory: true)
    }

    public init(fileURL: URL) {
        self.fileURL = fileURL
    }

    public init(directoryURL: URL, fileName: String = "latest-session.json") {
        fileURL = directoryURL.appendingPathComponent(fileName)
    }

    public func loadLatestSession() throws -> Session? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        return try decodeSession(at: fileURL)
    }

    public func loadSavedSessions() throws -> [Session] {
        var sessions: [Session] = []
        if FileManager.default.fileExists(atPath: historyDirectoryURL.path) {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: historyDirectoryURL,
                includingPropertiesForKeys: nil
            )
            for fileURL in fileURLs where fileURL.pathExtension == "json" {
                try sessions.append(decodeSession(at: fileURL))
            }
        }

        if let latestSession = try loadLatestSession() {
            if !sessions.contains(where: { $0.id == latestSession.id }) {
                sessions.append(latestSession)
            }
        }

        return sessions.sorted { lhs, rhs in
            lhs.updatedAt > rhs.updatedAt
        }
    }

    public func save(_ session: Session) throws {
        do {
            let data = try Self.encoder.encode(session)
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try FileManager.default.createDirectory(
                at: historyDirectoryURL,
                withIntermediateDirectories: true
            )
            try data.write(to: fileURL, options: [.atomic])
            try data.write(to: historyFileURL(for: session), options: [.atomic])
        } catch let error as EncodingError {
            throw SessionPersistenceError.encodingFailed(error.localizedDescription)
        } catch {
            throw SessionPersistenceError.writeFailed(error.localizedDescription)
        }
    }

    public func deleteSavedSession(id: Session.ID) throws {
        do {
            let historyFileURL = historyFileURL(for: id)
            if FileManager.default.fileExists(atPath: historyFileURL.path) {
                try FileManager.default.removeItem(at: historyFileURL)
            }

            let latestSessionID = try loadLatestSession()?.id
            if latestSessionID == id {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch let error as SessionPersistenceError {
            throw error
        } catch {
            throw SessionPersistenceError.deleteFailed(error.localizedDescription)
        }
    }

    private func decodeSession(at fileURL: URL) throws -> Session {
        do {
            let data = try Data(contentsOf: fileURL)
            return try Self.decoder.decode(Session.self, from: data)
        } catch let error as DecodingError {
            throw SessionPersistenceError.decodingFailed(error.localizedDescription)
        } catch {
            throw SessionPersistenceError.readFailed(error.localizedDescription)
        }
    }

    private func historyFileURL(for session: Session) -> URL {
        historyFileURL(for: session.id)
    }

    private func historyFileURL(for sessionID: Session.ID) -> URL {
        historyDirectoryURL.appendingPathComponent("\(sessionID.uuidString).json")
    }

    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }

    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

public enum SessionPersistenceError: LocalizedError, Equatable, Sendable {
    case readFailed(String)
    case writeFailed(String)
    case decodingFailed(String)
    case encodingFailed(String)
    case deleteFailed(String)

    public var errorDescription: String? {
        switch self {
        case .readFailed:
            "保存済みセッションを読み込めませんでした。"
        case .writeFailed:
            "セッションを保存できませんでした。"
        case .decodingFailed:
            "保存済みセッションの形式が壊れています。"
        case .encodingFailed:
            "セッションを保存形式に変換できませんでした。"
        case .deleteFailed:
            "保存済みセッションを削除できませんでした。"
        }
    }
}
