import Foundation
import PickleBallMatchingCore

@MainActor
extension OperationBoardViewModel {
    var bulkParticipantNamesToAdd: [String] {
        parsedBulkParticipantNames()
    }

    var canAddBulkParticipants: Bool {
        !bulkParticipantNamesToAdd.isEmpty
    }

    var canAddParticipant: Bool {
        !newParticipantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var bulkAddButtonTitle: String {
        let count = bulkParticipantNamesToAdd.count
        return count > 0 ? "\(count)人を追加" : "まとめて追加"
    }

    func addParticipant() {
        let name = newParticipantName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            return
        }

        session.participants.append(
            Participant(
                displayName: name,
                skillLevel: defaultSkillLevel(for: session.participants.count)
            )
        )
        newParticipantName = ""
        clearUndoHistory()
        persistSessionMutation()
    }

    func addBulkParticipants() {
        let names = parsedBulkParticipantNames()
        guard !names.isEmpty else {
            return
        }

        let initialCount = session.participants.count
        session.participants.append(
            contentsOf: names.enumerated().map { offset, name in
                Participant(
                    displayName: name,
                    skillLevel: defaultSkillLevel(for: initialCount + offset)
                )
            }
        )
        bulkParticipantNames = ""
        clearUndoHistory()
        persistSessionMutation()
    }

    private func parsedBulkParticipantNames() -> [String] {
        let separators = CharacterSet.newlines.union(CharacterSet(charactersIn: ",、\t"))
        var seenNames = Set(session.participants.map { normalizedParticipantName($0.displayName) })
        var names: [String] = []

        for rawName in bulkParticipantNames.components(separatedBy: separators) {
            let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = normalizedParticipantName(name)
            guard !name.isEmpty, !seenNames.contains(key) else {
                continue
            }

            seenNames.insert(key)
            names.append(name)
        }

        return names
    }

    private func normalizedParticipantName(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
    }

    private func defaultSkillLevel(for index: Int) -> SkillLevel {
        SkillLevel(rawValue: (index % SkillLevel.allCases.count) + 1) ?? .beginner
    }
}
