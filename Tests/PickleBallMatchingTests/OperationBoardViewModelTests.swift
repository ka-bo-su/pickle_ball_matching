@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardViewModelTests: XCTestCase {
    func testAddParticipantAppendsTrimmedName() {
        let viewModel = OperationBoardViewModel(session: Session(name: "テスト", participants: []))
        viewModel.newParticipantName = "  山田  "

        viewModel.addParticipant()

        XCTAssertEqual(viewModel.session.participants.map(\.displayName), ["山田"])
        XCTAssertEqual(viewModel.newParticipantName, "")
    }

    func testGenerateNextRoundUpdatesCurrentRoundAndWaiters() {
        let session = Session(
            name: "テスト",
            courtCount: 2,
            participants: makeParticipants(count: 10)
        )
        let viewModel = OperationBoardViewModel(session: session)

        viewModel.generateNextRound()

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.currentRound?.matches.count, 2)
        XCTAssertEqual(viewModel.currentRound?.waitingParticipants.count, 2)
    }

    func testGenerateNextRoundShowsErrorWhenParticipantsAreInsufficient() {
        let session = Session(name: "テスト", participants: makeParticipants(count: 3))
        let viewModel = OperationBoardViewModel(session: session)

        viewModel.generateNextRound()

        XCTAssertEqual(viewModel.errorMessage, "参加可能な人が4人未満です。")
        XCTAssertNil(viewModel.currentRound)
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
