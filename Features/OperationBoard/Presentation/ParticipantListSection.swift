import PickleBallMatchingCore
import SwiftUI

struct ParticipantListSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel
    @State private var selectedParticipant: Participant?

    var body: some View {
        Section("参加者") {
            addParticipantRow

            ForEach(viewModel.session.participants) { participant in
                participantRow(participant)
            }
            .onDelete(perform: viewModel.removeParticipants)
        }
        .sheet(item: $selectedParticipant) { participant in
            ParticipantDetailEditorView(participant: participant) { id, name, gender, ageGroup, memo in
                viewModel.updateParticipantDetails(
                    participantID: id,
                    displayName: name,
                    gender: gender,
                    ageGroup: ageGroup,
                    memo: memo
                )
            }
        }
    }

    private var addParticipantRow: some View {
        HStack {
            TextField("参加者名", text: $viewModel.newParticipantName)
                .textInputAutocapitalization(.never)
                .accessibilityLabel("参加者名入力")
            Button {
                viewModel.addParticipant()
            } label: {
                Label("追加", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("参加者を追加")
        }
    }

    private func participantRow(_ participant: Participant) -> some View {
        HStack {
            participantSummary(participant)
            Spacer()
            editButton(for: participant)
            skillLevelMenu(for: participant)
            statusMenu(for: participant)
            Text("待機 \(participant.waitingCount)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .accessibilityLabel("待機回数 \(participant.waitingCount)回")
        }
    }

    private func participantSummary(_ participant: Participant) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(participant.displayName)
                .font(.body)
            Text("\(participant.skillLevel.displayName)・\(participant.status.displayName)")
                .font(.caption)
                .foregroundStyle(.secondary)
            if !participantDetailSummary(participant).isEmpty {
                Text(participantDetailSummary(participant))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(participantAccessibilityLabel(participant))
    }

    private func editButton(for participant: Participant) -> some View {
        Button {
            selectedParticipant = participant
        } label: {
            Image(systemName: "pencil.circle")
                .imageScale(.large)
        }
        .buttonStyle(.borderless)
        .accessibilityLabel("\(participant.displayName)の詳細を編集")
    }

    private func skillLevelMenu(for participant: Participant) -> some View {
        Menu {
            ForEach(SkillLevel.allCases, id: \.self) { skillLevel in
                Button {
                    viewModel.updateParticipantSkillLevel(
                        participantID: participant.id,
                        skillLevel: skillLevel
                    )
                } label: {
                    Label(
                        skillLevel.displayName,
                        systemImage: skillLevel == participant.skillLevel ? "checkmark" : "circle"
                    )
                }
            }
        } label: {
            Label(participant.skillLevel.displayName, systemImage: "chart.bar")
                .labelStyle(.titleAndIcon)
                .font(.caption)
        }
        .accessibilityLabel("\(participant.displayName)のレベル \(participant.skillLevel.displayName)。変更")
    }

    private func statusMenu(for participant: Participant) -> some View {
        Menu {
            ForEach(ParticipantStatus.allCases, id: \.rawValue) { status in
                Button {
                    viewModel.updateParticipantStatus(participantID: participant.id, status: status)
                } label: {
                    Label(status.displayName, systemImage: status == participant.status ? "checkmark" : "circle")
                }
            }
        } label: {
            Label(
                participant.status.displayName,
                systemImage: participant.status.isAvailableForRound ? "checkmark.circle" : "pause.circle"
            )
            .labelStyle(.titleAndIcon)
            .font(.caption)
        }
        .accessibilityLabel("\(participant.displayName)の状態 \(participant.status.displayName)。変更")
    }

    private func participantAccessibilityLabel(_ participant: Participant) -> String {
        [
            participant.displayName,
            participant.skillLevel.displayName,
            participant.status.displayName,
            participantDetailSummary(participant)
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "、")
    }

    private func participantDetailSummary(_ participant: Participant) -> String {
        [
            participant.gender?.displayName,
            participant.ageGroup?.displayName,
            participant.memo.isEmpty ? nil : participant.memo
        ]
        .compactMap(\.self)
        .filter { $0 != "未設定" }
        .joined(separator: "・")
    }
}
