import PickleBallMatchingCore
import XCTest

final class OperationModeRulePresetTests: XCTestCase {
    func testBeginnerSessionPresetProtectsBeginnersAndReducesLevelGap() {
        let ruleSet = OperationMode.beginnerSession.defaultRuleSet

        XCTAssertTrue(ruleSet.protectsBeginners)
        XCTAssertTrue(ruleSet.reducesLevelGap)
        XCTAssertTrue(ruleSet.balancesWaitingCount)
        XCTAssertTrue(ruleSet.avoidsConsecutiveWaiting)
    }

    func testSocialMixPresetPrioritizesVarietyOverLevelGap() {
        let ruleSet = OperationMode.socialMix.defaultRuleSet

        XCTAssertTrue(ruleSet.avoidsRepeatedPairs)
        XCTAssertTrue(ruleSet.avoidsRepeatedOpponents)
        XCTAssertFalse(ruleSet.reducesLevelGap)
        XCTAssertFalse(ruleSet.protectsBeginners)
    }

    func testNormalPracticePresetKeepsCoreFairnessEnabled() {
        let ruleSet = OperationMode.normalPractice.defaultRuleSet

        XCTAssertTrue(ruleSet.balancesWaitingCount)
        XCTAssertTrue(ruleSet.avoidsConsecutiveWaiting)
        XCTAssertTrue(ruleSet.avoidsRepeatedPairs)
        XCTAssertTrue(ruleSet.avoidsRepeatedOpponents)
        XCTAssertTrue(ruleSet.reducesLevelGap)
    }
}
