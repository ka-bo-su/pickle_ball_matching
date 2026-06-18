import PickleBallMatchingCore

extension OperationBoardViewModel {
    func reapplyCurrentModeRulePreset() {
        let preset = session.mode.defaultRuleSet
        guard session.ruleSet != preset else {
            return
        }

        session.ruleSet = preset
        clearUndoHistory()
        persistSessionMutation()
    }

    func updateRule(_ keyPath: WritableKeyPath<SessionRuleSet, Bool>, isEnabled: Bool) {
        guard session.ruleSet[keyPath: keyPath] != isEnabled else {
            return
        }

        session.ruleSet[keyPath: keyPath] = isEnabled
        clearUndoHistory()
        persistSessionMutation()
    }
}
