import PickleBallMatchingCore
import SwiftUI

struct OperationBoardView: View {
    @StateObject private var viewModel: OperationBoardViewModel

    init(viewModel: OperationBoardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                sessionSection
                participantSection
                actionSection
                currentRoundSection
            }
            .navigationTitle("当日運営ボード")
        }
    }

    private var sessionSection: some View {
        Section("セッション") {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.session.name)
                    .font(.headline)
                Stepper(value: courtCountBinding, in: 1 ... 8) {
                    Label("\(viewModel.session.courtCount)面", systemImage: "sportscourt")
                }
                .accessibilityLabel("コート数 \(viewModel.session.courtCount)面")
                Label("\(viewModel.session.roundDurationMinutes)分ラウンド", systemImage: "timer")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var participantSection: some View {
        Section("参加者") {
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

            ForEach(viewModel.session.participants) { participant in
                participantRow(participant)
            }
            .onDelete(perform: viewModel.removeParticipants)
        }
    }

    private var actionSection: some View {
        Section {
            Button {
                viewModel.generateNextRound()
            } label: {
                Label("次ラウンド生成", systemImage: "shuffle")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(!viewModel.canGenerateRound)
            .accessibilityLabel("次ラウンドを生成")

            if let errorMessage = viewModel.errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.red)
                    .accessibilityLabel(errorMessage)
            }
        }
    }

    @ViewBuilder
    private var currentRoundSection: some View {
        if let round = viewModel.currentRound {
            Section("ラウンド\(round.number)") {
                ForEach(round.matches) { match in
                    matchRow(match)
                }

                if !round.waitingParticipants.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("待機", systemImage: "person.2.slash")
                            .font(.headline)
                        Text(round.waitingParticipants.map(\.displayName).joined(separator: "、"))
                            .font(.body)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("待機者 \(round.waitingParticipants.map(\.displayName).joined(separator: "、"))")
                }
            }
        } else {
            Section("進行ボード") {
                ContentUnavailableView("まだラウンドがありません", systemImage: "list.bullet.rectangle")
                    .accessibilityLabel("まだラウンドがありません")
            }
        }
    }

    private var courtCountBinding: Binding<Int> {
        Binding(
            get: { viewModel.session.courtCount },
            set: { viewModel.updateCourtCount($0) }
        )
    }

    private func participantRow(_ participant: Participant) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(participant.displayName)
                    .font(.body)
                Text("\(participant.skillLevel.displayName)・\(participant.status.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                "\(participant.displayName)、\(participant.skillLevel.displayName)、\(participant.status.displayName)"
            )
            Spacer()
            statusMenu(for: participant)
            Text("待機 \(participant.waitingCount)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .accessibilityLabel("待機回数 \(participant.waitingCount)回")
        }
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

    private func matchRow(_ match: Match) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("コート\(match.courtNumber)", systemImage: "sportscourt")
                .font(.headline)
            HStack(alignment: .top, spacing: 12) {
                teamColumn(title: "A", players: match.teamA.players)
                Text("vs")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                teamColumn(title: "B", players: match.teamB.players)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(matchAccessibilityLabel(match))
    }

    private func teamColumn(title: String, players: [Participant]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("チーム\(title)")
                .font(.caption)
                .foregroundStyle(.secondary)
            ForEach(players) { player in
                Text(player.displayName)
                    .font(.title3.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func matchAccessibilityLabel(_ match: Match) -> String {
        let teamA = match.teamA.players.map(\.displayName).joined(separator: "、")
        let teamB = match.teamB.players.map(\.displayName).joined(separator: "、")
        return "コート\(match.courtNumber)、\(teamA) 対 \(teamB)"
    }
}

#Preview {
    OperationBoardView(viewModel: OperationBoardViewModel())
}
