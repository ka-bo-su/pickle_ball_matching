@testable import PickleBallMatchingCore
import XCTest

final class MemberProfileQRPayloadTests: XCTestCase {
    func testRoundTripAllFields() throws {
        let profile = MemberProfile(
            displayName: "田中太郎",
            phoneticName: "タナカタロウ",
            skillLevel: .intermediate,
            gender: .male,
            ageGroup: .thirties,
            memo: "左利き"
        )

        let payload = MemberProfileQRPayload(profile: profile)
        let jsonString = try payload.encodeToJSONString()
        let decoded = try MemberProfileQRPayload.decode(from: jsonString)
        let restored = decoded.toMemberProfile()

        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.id, profile.id)
        XCTAssertEqual(restored?.displayName, profile.displayName)
        XCTAssertEqual(restored?.phoneticName, profile.phoneticName)
        XCTAssertEqual(restored?.skillLevel, profile.skillLevel)
        XCTAssertEqual(restored?.gender, profile.gender)
        XCTAssertEqual(restored?.ageGroup, profile.ageGroup)
        XCTAssertEqual(restored?.memo, profile.memo)
    }

    func testRoundTripOptionalFieldsNil() throws {
        let profile = MemberProfile(
            displayName: "山田花子",
            skillLevel: .beginner
        )

        let payload = MemberProfileQRPayload(profile: profile)
        let jsonString = try payload.encodeToJSONString()
        let decoded = try MemberProfileQRPayload.decode(from: jsonString)
        let restored = decoded.toMemberProfile()

        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.displayName, "山田花子")
        XCTAssertNil(restored?.phoneticName)
        XCTAssertNil(restored?.gender)
        XCTAssertNil(restored?.ageGroup)
        XCTAssertEqual(restored?.memo, "")
    }

    func testDecodeInvalidJSON() {
        XCTAssertThrowsError(try MemberProfileQRPayload.decode(from: "not-json"))
    }

    func testPayloadVersion() {
        let profile = MemberProfile(displayName: "テスト", skillLevel: .novice)
        let payload = MemberProfileQRPayload(profile: profile)
        XCTAssertEqual(payload.v, 1)
    }

    func testUnsupportedVersionReturnsNil() throws {
        let json = """
        {"v":99,"id":"550E8400-E29B-41D4-A716-446655440000","dn":"テスト","sl":2,"m":""}
        """
        let payload = try MemberProfileQRPayload.decode(from: json)
        XCTAssertNil(payload.toMemberProfile())
    }

    func testInvalidSkillLevelReturnsNil() throws {
        let json = """
        {"v":1,"id":"550E8400-E29B-41D4-A716-446655440000","dn":"テスト","sl":999,"m":""}
        """
        let payload = try MemberProfileQRPayload.decode(from: json)
        XCTAssertNil(payload.toMemberProfile())
    }

    func testToParticipantConversion() {
        let profile = MemberProfile(
            displayName: "佐藤次郎",
            phoneticName: "サトウジロウ",
            skillLevel: .advanced,
            gender: .male,
            ageGroup: .forties,
            memo: "経験5年"
        )

        let participant = profile.toParticipant()

        XCTAssertEqual(participant.id, profile.id)
        XCTAssertEqual(participant.displayName, profile.displayName)
        XCTAssertEqual(participant.phoneticName, profile.phoneticName)
        XCTAssertEqual(participant.skillLevel, profile.skillLevel)
        XCTAssertEqual(participant.gender, profile.gender)
        XCTAssertEqual(participant.ageGroup, profile.ageGroup)
        XCTAssertEqual(participant.memo, profile.memo)
        XCTAssertEqual(participant.status, .active)
        XCTAssertEqual(participant.playCount, 0)
        XCTAssertEqual(participant.waitingCount, 0)
        XCTAssertEqual(participant.consecutivePlayCount, 0)
        XCTAssertEqual(participant.consecutiveWaitCount, 0)
        XCTAssertNil(participant.fixedPairID)
    }
}
