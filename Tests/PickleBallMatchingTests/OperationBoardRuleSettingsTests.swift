@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class OperationBoardRuleSettingsTests: XCTestCase {
    func testUpdateRuleChangesRuleSetAndAutosaves() {
        let repository = RuleSettingsSpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(name: "テスト", ruleSet: .balancedPractice),
            sessionRepository: repository
        )

        viewModel.updateRule(\.avoidsRepeatedOpponents, isEnabled: false)

        XCTAssertFalse(viewModel.session.ruleSet.avoidsRepeatedOpponents)
        XCTAssertFalse(repository.savedSessions.last?.ruleSet.avoidsRepeatedOpponents ?? true)
    }

    func testUpdateRuleSkipsSaveWhenValueDoesNotChange() {
        let repository = RuleSettingsSpySessionRepository()
        let ruleSet = SessionRuleSet(avoidsRepeatedPairs: false)
        let viewModel = OperationBoardViewModel(
            session: Session(name: "テスト", ruleSet: ruleSet),
            sessionRepository: repository
        )

        viewModel.updateRule(\.avoidsRepeatedPairs, isEnabled: false)

        XCTAssertTrue(repository.savedSessions.isEmpty)
    }

    func testReapplyCurrentModeRulePresetRestoresPresetAndAutosaves() {
        let repository = RuleSettingsSpySessionRepository()
        let customRuleSet = SessionRuleSet(reducesLevelGap: true)
        let viewModel = OperationBoardViewModel(
            session: Session(
                name: "テスト",
                mode: .socialMix,
                ruleSet: customRuleSet
            ),
            sessionRepository: repository
        )

        viewModel.reapplyCurrentModeRulePreset()

        XCTAssertEqual(viewModel.session.ruleSet, OperationMode.socialMix.defaultRuleSet)
        XCTAssertEqual(repository.savedSessions.last?.ruleSet, OperationMode.socialMix.defaultRuleSet)
    }

    func testReapplyCurrentModeRulePresetSkipsSaveWhenPresetIsAlreadyApplied() {
        let repository = RuleSettingsSpySessionRepository()
        let viewModel = OperationBoardViewModel(
            session: Session(
                name: "テスト",
                mode: .beginnerSession,
                ruleSet: OperationMode.beginnerSession.defaultRuleSet
            ),
            sessionRepository: repository
        )

        viewModel.reapplyCurrentModeRulePreset()

        XCTAssertTrue(repository.savedSessions.isEmpty)
    }
}

final class RuleSettingsSpySessionRepository: SessionRepository, @unchecked Sendable {
    var savedSessions: [Session] = []

    func loadLatestSession() throws -> Session? {
        nil
    }

    func loadSavedSessions() throws -> [Session] {
        []
    }

    func save(_ session: Session) throws {
        savedSessions.append(session)
    }
}
