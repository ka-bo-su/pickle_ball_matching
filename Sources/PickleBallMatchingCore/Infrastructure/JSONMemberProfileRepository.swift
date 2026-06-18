import Foundation

public struct JSONMemberProfileRepository: MemberProfileRepository {
    private let fileURL: URL

    public init(directoryURL: URL, fileName: String = "member-profile.json") {
        fileURL = directoryURL.appendingPathComponent(fileName)
    }

    public func loadProfile() throws -> MemberProfile? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode(MemberProfile.self, from: data)
    }

    public func save(_ profile: MemberProfile) throws {
        let directory = fileURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(profile)
        try data.write(to: fileURL, options: .atomic)
    }
}
