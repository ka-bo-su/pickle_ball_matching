@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardSummaryModelTests: XCTestCase {
    func testPromptsParticipantSetupWhenParticipantsAreInsufficient() {
        let session = Session(name: "テスト", courtCount: 2, participants: makeParticipants(count: 3))
        let viewModel = OperationBoardViewModel(session: session)

        let summary = viewModel.boardSummaryModel

        XCTAssertEqual(summary.statusTitle, "参加者を準備中")
        XCTAssertEqual(summary.statusDetail, "参加可能な人があと1人必要です")
        XCTAssertEqual(summary.participantSummary, "参加可能 3人 / 登録 3人")
        XCTAssertEqual(summary.waitingSummary, "ラウンド生成には4人以上必要です")
        XCTAssertTrue(summary.nextActionDetail.contains("参加者を追加"))
        XCTAssertTrue(summary.accessibilityLabel.contains("参加者を準備中"))
    }

    func testPromptsRoundGenerationWhenReady() {
        let session = Session(name: "テスト", courtCount: 1, participants: makeParticipants(count: 4))
        let viewModel = OperationBoardViewModel(session: session)

        let summary = viewModel.boardSummaryModel

        XCTAssertEqual(summary.statusTitle, "最初のラウンドを作れます")
        XCTAssertEqual(summary.statusDetail, "準備できています")
        XCTAssertEqual(summary.participantSummary, "参加可能 4人 / 登録 4人")
        XCTAssertEqual(summary.courtSummary, "設定 1面・12分")
        XCTAssertTrue(summary.nextActionDetail.contains("次ラウンド生成"))
    }

    func testSummarizesCurrentRoundAndNextAction() {
        let session = Session(
            name: "初心者会",
            courtCount: 2,
            participants: makeParticipants(count: 10)
        )
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()

        let summary = viewModel.boardSummaryModel

        XCTAssertEqual(summary.statusTitle, "現在 ラウンド1")
        XCTAssertEqual(summary.statusDetail, "2面で進行中")
        XCTAssertEqual(summary.participantSummary, "参加可能 10人 / 登録 10人")
        XCTAssertEqual(summary.waitingSummary, "待機 2人")
        XCTAssertTrue(summary.nextActionDetail.contains("入れ替え"))
    }

    private func makeParticipants(count: Int) -> [Participant] {
        (1 ... count).map { index in
            Participant(
                id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", index))!,
                displayName: "参加者\(index)",
                skillLevel: SkillLevel(rawValue: (index % 4) + 1) ?? .beginner
            )
        }
    }
}
