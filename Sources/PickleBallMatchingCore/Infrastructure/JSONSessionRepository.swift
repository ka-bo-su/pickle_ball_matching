import Foundation

public struct JSONSessionRepository: SessionRepository {
    private let fileURL: URL

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

        do {
            let data = try Data(contentsOf: fileURL)
            return try Self.decoder.decode(Session.self, from: data)
        } catch let error as DecodingError {
            throw SessionPersistenceError.decodingFailed(error.localizedDescription)
        } catch {
            throw SessionPersistenceError.readFailed(error.localizedDescription)
        }
    }

    public func save(_ session: Session) throws {
        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try Self.encoder.encode(session)
            try data.write(to: fileURL, options: [.atomic])
        } catch let error as EncodingError {
            throw SessionPersistenceError.encodingFailed(error.localizedDescription)
        } catch {
            throw SessionPersistenceError.writeFailed(error.localizedDescription)
        }
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
        }
    }
}
