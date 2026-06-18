@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardModeSettingsTests: XCTestCase {
    func testUpdateOperationModeAppliesRulePresetAndAutosaves() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "テスト", mode: .normalPractice),
            sessionRepository: repository
        )

        viewModel.updateOperationMode(.beginnerSession)

        XCTAssertEqual(viewModel.session.mode, .beginnerSession)
        XCTAssertEqual(viewModel.session.ruleSet, OperationMode.beginnerSession.defaultRuleSet)
        XCTAssertEqual(repository.savedSessions.last?.mode, .beginnerSession)
        XCTAssertEqual(repository.savedSessions.last?.ruleSet, OperationMode.beginnerSession.defaultRuleSet)
    }

    func testUpdateOperationModeSkipsSaveWhenModeDoesNotChange() {
        let repository = SpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "テスト", mode: .normalPractice),
            sessionRepository: repository
        )

        viewModel.updateOperationMode(.normalPractice)

        XCTAssertTrue(repository.savedSessions.isEmpty)
    }
}
