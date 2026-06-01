import PickleBallMatchingCore
import SwiftUI

struct ParticipantDetailEditorView: View {
    let participant: Participant
    let onSave: (Participant.ID, String, Gender, AgeGroup, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var displayName: String
    @State private var gender: Gender
    @State private var ageGroup: AgeGroup
    @State private var memo: String

    init(
        participant: Participant,
        onSave: @escaping (Participant.ID, String, Gender, AgeGroup, String) -> Void
    ) {
        self.participant = participant
        self.onSave = onSave
        _displayName = State(initialValue: participant.displayName)
        _gender = State(initialValue: participant.gender ?? .notSpecified)
        _ageGroup = State(initialValue: participant.ageGroup ?? .notSpecified)
        _memo = State(initialValue: participant.memo)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("表示名", text: $displayName)
                        .textInputAutocapitalization(.never)
                        .accessibilityLabel("表示名")

                    Picker("性別", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.displayName)
                                .tag(gender)
                        }
                    }
                    .accessibilityLabel("性別 \(gender.displayName)")

                    Picker("年齢帯", selection: $ageGroup) {
                        ForEach(AgeGroup.allCases, id: \.self) { ageGroup in
                            Text(ageGroup.displayName)
                                .tag(ageGroup)
                        }
                    }
                    .accessibilityLabel("年齢帯 \(ageGroup.displayName)")
                }

                Section("メモ") {
                    TextEditor(text: $memo)
                        .frame(minHeight: 96)
                        .accessibilityLabel("参加者メモ")
                }
            }
            .navigationTitle("参加者詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        onSave(participant.id, displayName, gender, ageGroup, memo)
                        dismiss()
                    }
                    .disabled(displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
