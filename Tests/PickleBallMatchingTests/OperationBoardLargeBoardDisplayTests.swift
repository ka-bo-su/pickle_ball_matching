import Foundation
@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardLargeBoardDisplayTests: XCTestCase {
    func testLargeBoardDisplayModelSummarizesCurrentRound() throws {
        let session = Session(
            name: "初心者会",
            courtCount: 2,
            participants: makeParticipants(count: 10)
        )
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()

        let model = try XCTUnwrap(viewModel.largeBoardDisplayModel)

        XCTAssertEqual(model.sessionName, "初心者会")
        XCTAssertEqual(model.roundTitle, "ラウンド1")
        XCTAssertEqual(model.roundStatusTitle, "未開始")
        XCTAssertEqual(model.remainingTimeText, "12:00")
        XCTAssertEqual(model.courts.count, 2)
        XCTAssertEqual(model.waitingPlayerNames.count, 2)
        XCTAssertEqual(model.waitingTitle, "待機者")
        XCTAssertTrue(model.announcement.hasPrefix("待機 "))
        XCTAssertTrue(model.courts.first?.courtTitle == "コート1")
        XCTAssertTrue(model.courts.first?.accessibilityLabel.contains("チームA") == true)
        XCTAssertTrue(model.timingAccessibilityLabel.contains("残り時間 12:00"))
    }

    func testLargeBoardDisplayModelShowsRemainingTimeForInProgressRound() throws {
        let referenceDate = try XCTUnwrap(DateComponents(
            calendar: Calendar(identifier: .gregorian),
            year: 2026,
            month: 6,
            day: 2,
            hour: 10
        ).date)
        let session = Session(
            name: "通常練習",
            courtCount: 1,
            roundDurationMinutes: 12,
            participants: makeParticipants(count: 4)
        )
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()
        var round = try XCTUnwrap(viewModel.session.currentRound)
        round.startedAt = referenceDate.addingTimeInterval(-90)
        viewModel.session.rounds[viewModel.session.rounds.count - 1] = round

        let model = try XCTUnwrap(viewModel.largeBoardDisplayModel(now: referenceDate))

        XCTAssertEqual(model.roundStatusTitle, "進行中")
        XCTAssertEqual(model.remainingTimeText, "10:30")
        XCTAssertTrue(model.timingDetailText.contains("試合中です"))
        XCTAssertEqual(
            model.timingAccessibilityLabel,
            "進行中、残り時間 10:30、試合中です。終了したらラウンド終了を押します。"
        )
    }

    func testLargeBoardDisplayModelShowsNoWaitersWhenEveryonePlays() throws {
        let session = Session(
            name: "通常練習",
            courtCount: 1,
            participants: makeParticipants(count: 4)
        )
        let viewModel = OperationBoardViewModel(session: session)
        viewModel.generateNextRound()

        let model = try XCTUnwrap(viewModel.largeBoardDisplayModel)

        XCTAssertEqual(model.waitingTitle, "待機なし")
        XCTAssertEqual(model.waitingSummary, "全員がコートに入っています")
        XCTAssertEqual(model.announcement, "待機者はいません")
    }

    func testLargeBoardDisplayModelIsNilBeforeRoundGeneration() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト"))

        XCTAssertNil(viewModel.largeBoardDisplayModel)
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
