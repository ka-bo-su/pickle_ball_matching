import PickleBallMatchingCore

extension OperationBoardViewModel {
    func updateRule(_ keyPath: WritableKeyPath<SessionRuleSet, Bool>, isEnabled: Bool) {
        guard session.ruleSet[keyPath: keyPath] != isEnabled else {
            return
        }

        session.ruleSet[keyPath: keyPath] = isEnabled
        clearUndoHistory()
        persistSessionMutation()
    }
}
