import PickleBallMatchingCore
import SwiftUI

struct ParticipantListSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel
    @State private var selectedParticipant: Participant?
    @State private var isShowingBulkAdd = false
    @State private var deletionCandidate: Participant?

    var body: some View {
        Section("参加者") {
            participantStatusSummary
            participantSetupGuide
            addParticipantRow
            bulkAddParticipantRow

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
        .confirmationDialog(
            "参加者を削除しますか？",
            isPresented: deletionConfirmationBinding,
            presenting: deletionCandidate
        ) { participant in
            Button("削除", role: .destructive) {
                viewModel.removeParticipant(participantID: participant.id)
                deletionCandidate = nil
            }
            Button("キャンセル", role: .cancel) {
                deletionCandidate = nil
            }
        } message: { participant in
            Text("\(participant.displayName)を今日の参加者一覧から削除します。過去ラウンド履歴は残ります。")
        }
    }

    private var participantStatusSummary: some View {
        let summary = ParticipantStatusSummaryModel(participants: viewModel.session.participants)
        return VStack(alignment: .leading, spacing: 4) {
            Label(summary.headline, systemImage: "person.3.sequence")
                .font(.subheadline.weight(.semibold))
            Text(summary.detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(summary.accessibilityLabel)
    }

    private var participantSetupGuide: some View {
        let guide = ParticipantSetupGuideModel(
            participants: viewModel.session.participants,
            courtCount: viewModel.session.courtCount
        )
        return Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(guide.title)
                    .font(.subheadline.weight(.semibold))
                Text(guide.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        } icon: {
            Image(systemName: guide.systemImage)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(guide.accessibilityLabel)
    }

    private var addParticipantRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("参加者名", text: $viewModel.newParticipantName)
                .textInputAutocapitalization(.never)
                .submitLabel(.done)
                .onSubmit {
                    viewModel.addParticipant()
                }
                .accessibilityLabel("参加者名入力")
            if let warning = viewModel.participantNameInputWarning {
                Label(warning, systemImage: "exclamationmark.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(warning)
            }
            Button {
                viewModel.addParticipant()
            } label: {
                Label("参加者を追加", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(!viewModel.canAddParticipant)
            .accessibilityLabel("参加者を追加")
            .accessibilityHint("入力した名前を今日の参加者一覧に追加します")
        }
    }

    private var bulkAddParticipantRow: some View {
        DisclosureGroup(isExpanded: $isShowingBulkAdd) {
            VStack(alignment: .leading, spacing: 8) {
                TextField("参加者名簿", text: $viewModel.bulkParticipantNames, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .lineLimit(3 ... 6)
                    .accessibilityLabel("まとめて追加する参加者名簿")

                Button {
                    viewModel.addBulkParticipants()
                } label: {
                    Label(viewModel.bulkAddButtonTitle, systemImage: "text.badge.plus")
                }
                .buttonStyle(.borderless)
                .disabled(!viewModel.canAddBulkParticipants)
                .accessibilityLabel(viewModel.bulkAddButtonTitle)
            }
        } label: {
            Label("まとめて追加", systemImage: "text.badge.plus")
        }
    }

    private func participantRow(_ participant: Participant) -> some View {
        HStack {
            participantSummary(participant)
            Spacer()
            editButton(for: participant)
            attendanceToggleButton(for: participant)
            skillLevelMenu(for: participant)
            statusMenu(for: participant)
            deleteButton(for: participant)
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

    private func attendanceToggleButton(for participant: Participant) -> some View {
        Button {
            viewModel.toggleParticipantAttendance(participantID: participant.id)
        } label: {
            Image(systemName: attendanceToggleSystemImage(for: participant))
                .imageScale(.large)
        }
        .buttonStyle(.borderless)
        .accessibilityLabel(attendanceToggleAccessibilityLabel(for: participant))
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

    private func deleteButton(for participant: Participant) -> some View {
        Button(role: .destructive) {
            deletionCandidate = participant
        } label: {
            Image(systemName: "trash.circle")
                .imageScale(.large)
        }
        .buttonStyle(.borderless)
        .accessibilityLabel("\(participant.displayName)を削除")
    }

    private var deletionConfirmationBinding: Binding<Bool> {
        Binding(
            get: { deletionCandidate != nil },
            set: { isPresented in
                if !isPresented {
                    deletionCandidate = nil
                }
            }
        )
    }

    private func attendanceToggleSystemImage(for participant: Participant) -> String {
        if participant.status.isAvailableForRound {
            return "person.crop.circle.badge.xmark"
        }

        return "person.crop.circle.badge.checkmark"
    }

    private func attendanceToggleAccessibilityLabel(for participant: Participant) -> String {
        if participant.status.isAvailableForRound {
            return "\(participant.displayName)を欠席にする"
        }

        return "\(participant.displayName)を参加中に戻す"
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
