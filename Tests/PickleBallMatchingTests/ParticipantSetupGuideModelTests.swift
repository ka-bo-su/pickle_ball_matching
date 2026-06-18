@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

final class ParticipantSetupGuideModelTests: XCTestCase {
    func testGuidesParticipantAdditionWhenEmpty() {
        let guide = ParticipantSetupGuideModel(participants: [], courtCount: 1)

        XCTAssertEqual(guide.title, "まず参加者を追加")
        XCTAssertTrue(guide.detail.contains("最低4人"))
        XCTAssertEqual(guide.systemImage, "person.badge.plus")
        XCTAssertTrue(guide.accessibilityLabel.contains("参加者"))
    }

    func testGuidesAvailableParticipantCountWhenInsufficient() {
        let participants = makeParticipants(count: 3)

        let guide = ParticipantSetupGuideModel(participants: participants, courtCount: 1)

        XCTAssertEqual(guide.title, "あと1人で生成可能")
        XCTAssertTrue(guide.detail.contains("参加中または代替参加"))
        XCTAssertEqual(guide.systemImage, "person.crop.circle.badge.exclamationmark")
    }

    func testGuidesExpectedWaitingCountWhenReady() {
        let participants = makeParticipants(count: 6)

        let guide = ParticipantSetupGuideModel(participants: participants, courtCount: 2)

        XCTAssertEqual(guide.title, "ラウンド生成の準備完了")
        XCTAssertTrue(guide.detail.contains("待機は2人"))
        XCTAssertEqual(guide.systemImage, "checkmark.circle")
    }

    private func makeParticipants(count: Int) -> [Participant] {
        (1 ... count).map { index in
            Participant(
                id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", index))!,
                displayName: "参加者\(index)",
                skillLevel: .beginner
            )
        }
    }
}
