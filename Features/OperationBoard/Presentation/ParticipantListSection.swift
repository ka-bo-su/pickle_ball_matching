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
        return VStack(alignment: .leading, spacing: 6) {
            Label(summary.headline, systemImage: "person.3.sequence")
                .font(.headline)
            Text(summary.detail)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
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
                    .font(.headline)
                Text(guide.detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        } icon: {
            Image(systemName: guide.systemImage)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(guide.accessibilityLabel)
    }

    private var addParticipantRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("参加者名", text: $viewModel.newParticipantName)
                .font(.title3)
                .textInputAutocapitalization(.never)
                .submitLabel(.done)
                .onSubmit {
                    viewModel.addParticipant()
                }
                .accessibilityLabel("参加者名入力")
            if let warning = viewModel.participantNameInputWarning {
                Label(warning, systemImage: "exclamationmark.circle")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(warning)
            }
            Button {
                viewModel.addParticipant()
            } label: {
                Label("参加者を追加", systemImage: "plus.circle.fill")
                    .font(.title3.weight(.bold))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.canAddParticipant)
            .accessibilityLabel("参加者を追加")
            .accessibilityHint("入力した名前を今日の参加者一覧に追加します")
        }
        .padding(.vertical, 6)
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
                .font(.body.weight(.semibold))
        }
    }

    private func participantRow(_ participant: Participant) -> some View {
        ParticipantRowView(
            participant: participant,
            onEdit: {
                selectedParticipant = participant
            },
            onToggleAttendance: {
                viewModel.toggleParticipantAttendance(participantID: participant.id)
            },
            onUpdateSkillLevel: { skillLevel in
                viewModel.updateParticipantSkillLevel(
                    participantID: participant.id,
                    skillLevel: skillLevel
                )
            },
            onUpdateStatus: { status in
                viewModel.updateParticipantStatus(participantID: participant.id, status: status)
            },
            onDelete: {
                deletionCandidate = participant
            }
        )
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
}
