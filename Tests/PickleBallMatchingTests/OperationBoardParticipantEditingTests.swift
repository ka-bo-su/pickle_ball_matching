@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardParticipantEditingTests: XCTestCase {
    func testUpdateParticipantSkillLevelChangesLevelAndAutosaves() throws {
        let repository = SpySessionRepository()
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let session = Session(
            name: "テスト",
            participants: [
                Participant(id: participantID, displayName: "山田", skillLevel: .beginner)
            ]
        )
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.updateParticipantSkillLevel(participantID: participantID, skillLevel: .advanced)

        XCTAssertEqual(viewModel.session.participants.first?.skillLevel, .advanced)
        XCTAssertEqual(repository.savedSessions.last?.participants.first?.skillLevel, .advanced)
    }

    func testUpdateParticipantDetailsChangesOptionalFieldsAndAutosaves() throws {
        let repository = SpySessionRepository()
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let session = Session(
            name: "テスト",
            participants: [
                Participant(id: participantID, displayName: "山田")
            ]
        )
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.updateParticipantDetails(
            participantID: participantID,
            displayName: "  山田太郎  ",
            gender: .male,
            ageGroup: .forties,
            memo: "  左利き  "
        )

        let participant = try XCTUnwrap(viewModel.session.participants.first)
        XCTAssertEqual(participant.displayName, "山田太郎")
        XCTAssertEqual(participant.gender, .male)
        XCTAssertEqual(participant.ageGroup, .forties)
        XCTAssertEqual(participant.memo, "左利き")
        XCTAssertEqual(repository.savedSessions.last?.participants.first, participant)
    }

    func testUpdateParticipantDetailsIgnoresEmptyName() throws {
        let repository = SpySessionRepository()
        let participantID = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000001"))
        let session = Session(
            name: "テスト",
            participants: [
                Participant(id: participantID, displayName: "山田")
            ]
        )
        let viewModel = OperationBoardViewModel(session: session, sessionRepository: repository)

        viewModel.updateParticipantDetails(
            participantID: participantID,
            displayName: "   ",
            gender: .female,
            ageGroup: .twenties,
            memo: "空名"
        )

        XCTAssertEqual(viewModel.session.participants.first?.displayName, "山田")
        XCTAssertTrue(repository.savedSessions.isEmpty)
    }
}
