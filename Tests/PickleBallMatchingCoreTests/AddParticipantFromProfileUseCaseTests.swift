@testable import PickleBallMatchingCore
import XCTest

final class AddParticipantFromProfileUseCaseTests: XCTestCase {
    private var sut: AddParticipantFromProfileUseCase!

    override func setUp() {
        super.setUp()
        sut = AddParticipantFromProfileUseCase()
    }

    private func makeSession() -> Session {
        Session(name: "テストセッション", courtCount: 2)
    }

    func testAddsParticipantFromProfile() throws {
        let session = makeSession()
        let profile = MemberProfile(
            displayName: "テスト太郎",
            skillLevel: .intermediate
        )

        let updated = try sut.execute(session: session, profile: profile)

        XCTAssertEqual(updated.participants.count, 1)
        XCTAssertEqual(updated.participants[0].id, profile.id)
        XCTAssertEqual(updated.participants[0].displayName, "テスト太郎")
        XCTAssertEqual(updated.participants[0].skillLevel, .intermediate)
    }

    func testThrowsWhenDuplicateProfile() throws {
        let profile = MemberProfile(
            displayName: "テスト太郎",
            skillLevel: .beginner
        )

        var session = makeSession()
        session = try sut.execute(session: session, profile: profile)

        XCTAssertThrowsError(
            try sut.execute(session: session, profile: profile)
        ) { error in
            XCTAssertEqual(error as? AddParticipantError, .alreadyExists)
        }
    }

    func testPreservesExistingParticipants() throws {
        var session = makeSession()
        session.participants.append(
            Participant(displayName: "既存メンバー", skillLevel: .advanced)
        )
        let profile = MemberProfile(
            displayName: "新メンバー",
            skillLevel: .beginner
        )

        let updated = try sut.execute(session: session, profile: profile)

        XCTAssertEqual(updated.participants.count, 2)
        XCTAssertEqual(updated.participants[0].displayName, "既存メンバー")
        XCTAssertEqual(updated.participants[1].displayName, "新メンバー")
    }

    func testCopiesAllProfileFields() throws {
        let session = makeSession()
        let profile = MemberProfile(
            displayName: "田中花子",
            phoneticName: "タナカハナコ",
            skillLevel: .advanced,
            gender: .female,
            ageGroup: .thirties,
            memo: "左利き"
        )

        let updated = try sut.execute(session: session, profile: profile)

        let participant = updated.participants[0]
        XCTAssertEqual(participant.id, profile.id)
        XCTAssertEqual(participant.displayName, "田中花子")
        XCTAssertEqual(participant.skillLevel, .advanced)
        XCTAssertEqual(participant.gender, Gender.female)
        XCTAssertEqual(participant.ageGroup, AgeGroup.thirties)
        XCTAssertEqual(participant.memo, "左利き")
    }

    func testUpdatesSessionTimestamp() throws {
        let session = makeSession()
        let before = session.updatedAt
        let profile = MemberProfile(
            displayName: "テスト",
            skillLevel: .beginner
        )

        let updated = try sut.execute(session: session, profile: profile)

        XCTAssertGreaterThanOrEqual(updated.updatedAt, before)
    }
}
