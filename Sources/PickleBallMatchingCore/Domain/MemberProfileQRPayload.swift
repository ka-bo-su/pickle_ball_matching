import Foundation

public struct MemberProfileQRPayload: Codable, Equatable, Sendable {
    public let v: Int
    public let id: UUID
    public let dn: String
    public let pn: String?
    public let sl: Int
    public let g: String?
    public let ag: String?
    public let m: String

    public init(profile: MemberProfile) {
        v = 1
        id = profile.id
        dn = profile.displayName
        pn = profile.phoneticName
        sl = profile.skillLevel.rawValue
        g = profile.gender?.rawValue
        ag = profile.ageGroup?.rawValue
        m = profile.memo
    }

    public func toMemberProfile() -> MemberProfile? {
        guard v == 1, let skillLevel = SkillLevel(rawValue: sl) else {
            return nil
        }
        let gender: Gender? = g.flatMap { Gender(rawValue: $0) }
        let ageGroup: AgeGroup? = ag.flatMap { AgeGroup(rawValue: $0) }

        return MemberProfile(
            id: id,
            displayName: dn,
            phoneticName: pn,
            skillLevel: skillLevel,
            gender: gender,
            ageGroup: ageGroup,
            memo: m
        )
    }

    public func encodeToJSONString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(self)
        guard let string = String(data: data, encoding: .utf8) else {
            throw MemberProfileQRPayloadError.encodingFailed
        }
        return string
    }

    public static func decode(from jsonString: String) throws -> MemberProfileQRPayload {
        guard let data = jsonString.data(using: .utf8) else {
            throw MemberProfileQRPayloadError.invalidData
        }
        return try JSONDecoder().decode(MemberProfileQRPayload.self, from: data)
    }
}

public enum MemberProfileQRPayloadError: LocalizedError, Sendable {
    case encodingFailed
    case invalidData
    case unsupportedVersion

    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            "QRコードデータのエンコードに失敗しました。"
        case .invalidData:
            "QRコードのデータが不正です。"
        case .unsupportedVersion:
            "このQRコードのバージョンには対応していません。"
        }
    }
}
