@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardRoundTimingTests: XCTestCase {
    func testTimingModelIsNilBeforeRoundGeneration() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト"))

        XCTAssertNil(viewModel.currentRoundTimingModel(now: referenceDate))
    }

    func testTimingModelShowsScheduledRoundBeforeStart() throws {
        let viewModel = OperationBoardViewModel(session: makeSession())
        viewModel.generateNextRound()

        let timing = try XCTUnwrap(viewModel.currentRoundTimingModel(now: referenceDate))

        XCTAssertEqual(timing.statusTitle, "未開始")
        XCTAssertEqual(timing.remainingTimeText, "12:00")
        XCTAssertTrue(timing.canStart)
        XCTAssertTrue(timing.canFinish)
        XCTAssertTrue(timing.detailText.contains("試合開始"))
    }

    func testStartCurrentRoundMarksMatchesInProgressAndAutosaves() throws {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(session: makeSession(), sessionRepository: repository)
        viewModel.generateNextRound()

        viewModel.startCurrentRound(at: referenceDate)

        let round = try XCTUnwrap(viewModel.currentRound)
        XCTAssertEqual(round.startedAt, referenceDate)
        XCTAssertEqual(round.status, .inProgress)
        XCTAssertTrue(round.matches.allSatisfy { $0.status == .inProgress })
        XCTAssertEqual(repository.savedSessions.last?.currentRound?.startedAt, referenceDate)

        let timing = try XCTUnwrap(
            viewModel.currentRoundTimingModel(now: referenceDate.addingTimeInterval(90))
        )
        XCTAssertEqual(timing.statusTitle, "進行中")
        XCTAssertEqual(timing.remainingTimeText, "10:30")
        XCTAssertFalse(timing.canStart)
        XCTAssertTrue(timing.canFinish)
    }

    func testTimingModelShowsTimeUpWhenExpired() throws {
        let viewModel = OperationBoardViewModel(session: makeSession(roundDurationMinutes: 1))
        viewModel.generateNextRound()
        viewModel.startCurrentRound(at: referenceDate)

        let timing = try XCTUnwrap(
            viewModel.currentRoundTimingModel(now: referenceDate.addingTimeInterval(90))
        )

        XCTAssertEqual(timing.statusTitle, "時間です")
        XCTAssertEqual(timing.remainingTimeText, "00:00")
        XCTAssertTrue(timing.detailText.contains("ラウンド終了"))
    }

    func testFinishCurrentRoundMarksMatchesFinishedAndAutosaves() throws {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(session: makeSession(), sessionRepository: repository)
        viewModel.generateNextRound()
        viewModel.startCurrentRound(at: referenceDate)
        let finishedAt = referenceDate.addingTimeInterval(600)

        viewModel.finishCurrentRound(at: finishedAt)

        let round = try XCTUnwrap(viewModel.currentRound)
        XCTAssertEqual(round.finishedAt, finishedAt)
        XCTAssertEqual(round.status, .finished)
        XCTAssertTrue(round.matches.allSatisfy { $0.status == .finished })
        XCTAssertEqual(repository.savedSessions.last?.currentRound?.finishedAt, finishedAt)

        let timing = try XCTUnwrap(
            viewModel.currentRoundTimingModel(now: finishedAt.addingTimeInterval(10))
        )
        XCTAssertEqual(timing.statusTitle, "終了")
        XCTAssertEqual(timing.remainingTimeText, "00:00")
        XCTAssertFalse(timing.canStart)
        XCTAssertFalse(timing.canFinish)
    }

    private var referenceDate: Date {
        Date(timeIntervalSince1970: 1_700_000_000)
    }

    private func makeSession(roundDurationMinutes: Int = 12) -> Session {
        Session(
            name: "テスト",
            courtCount: 1,
            roundDurationMinutes: roundDurationMinutes,
            participants: makeParticipants(count: 4)
        )
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
