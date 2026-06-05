@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

final class ParticipantStatusSummaryModelTests: XCTestCase {
    func testSummarizesRegisteredAndAvailableParticipants() {
        let summary = ParticipantStatusSummaryModel(
            participants: [
                Participant(displayName: "山田", status: .active),
                Participant(displayName: "佐藤", status: .substitute),
                Participant(displayName: "鈴木", status: .wantsBreak),
                Participant(displayName: "田中", status: .absent),
                Participant(displayName: "高橋", status: .late),
                Participant(displayName: "伊藤", status: .leavingEarly)
            ]
        )

        XCTAssertEqual(summary.headline, "登録 6人・参加可能 3人")
        XCTAssertEqual(summary.detail, "遅刻 1人、休憩希望 1人、途中退出予定 1人、欠席 1人、代替参加 1人")
        XCTAssertTrue(summary.accessibilityLabel.contains("登録 6人"))
        XCTAssertTrue(summary.accessibilityLabel.contains("休憩希望 1人"))
    }

    func testShowsAllAvailableWhenNoAttentionStatusExists() {
        let summary = ParticipantStatusSummaryModel(
            participants: [
                Participant(displayName: "山田", status: .active),
                Participant(displayName: "佐藤", status: .active)
            ]
        )

        XCTAssertEqual(summary.headline, "登録 2人・参加可能 2人")
        XCTAssertEqual(summary.detail, "全員参加可能です")
        XCTAssertEqual(summary.accessibilityLabel, "登録 2人・参加可能 2人、全員参加可能です")
    }
}
