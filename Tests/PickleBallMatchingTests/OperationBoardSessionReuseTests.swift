@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardSessionReuseTests: XCTestCase {
    func testStartNewSessionKeepingRosterPreservesProfileAndResetsProgress() throws {
        let repository = SpySessionRepository()
        let fixedPairID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000099"))
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let participant = Participant(
            id: participantID,
            displayName: "山田",
            phoneticName: "やまだ",
            skillLevel: .advanced,
            gender: .male,
            ageGroup: .forties,
            memo: "左利き",
            status: .wantsBreak,
            fixedPairID: fixedPairID,
            playCount: 3,
            waitingCount: 2,
            consecutivePlayCount: 1,
            consecutiveWaitCount: 2
        )
        var session = Session(name: "前回", courtCount: 1, participants: [participant])
        session.rounds = [
            Round(number: 1, matches: [], waitingParticipants: [participant])
        ]
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.startNewSessionKeepingRoster()

        let inheritedParticipant = try XCTUnwrap(viewModel.session.participants.first)
        XCTAssertEqual(viewModel.session.name, "今日のピックルボール")
        XCTAssertEqual(viewModel.session.courtCount, 2)
        XCTAssertTrue(viewModel.session.rounds.isEmpty)
        XCTAssertFalse(viewModel.canUndo)
        XCTAssertEqual(inheritedParticipant.id, participantID)
        XCTAssertEqual(inheritedParticipant.displayName, "山田")
        XCTAssertEqual(inheritedParticipant.phoneticName, "やまだ")
        XCTAssertEqual(inheritedParticipant.skillLevel, .advanced)
        XCTAssertEqual(inheritedParticipant.gender, .male)
        XCTAssertEqual(inheritedParticipant.ageGroup, .forties)
        XCTAssertEqual(inheritedParticipant.memo, "左利き")
        XCTAssertEqual(inheritedParticipant.fixedPairID, fixedPairID)
        XCTAssertEqual(inheritedParticipant.status, .active)
        XCTAssertEqual(inheritedParticipant.playCount, 0)
        XCTAssertEqual(inheritedParticipant.waitingCount, 0)
        XCTAssertEqual(inheritedParticipant.consecutivePlayCount, 0)
        XCTAssertEqual(inheritedParticipant.consecutiveWaitCount, 0)
        XCTAssertEqual(repository.savedSessions.last?.participants.first, inheritedParticipant)
    }
}
