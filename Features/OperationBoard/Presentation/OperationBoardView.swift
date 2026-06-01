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
        SessionSettingsSection(viewModel: viewModel)
    }

    private var participantSection: some View {
        ParticipantListSection(viewModel: viewModel)
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

            Button {
                viewModel.undoLastChange()
            } label: {
                Label("1手戻す", systemImage: "arrow.uturn.backward")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(!viewModel.canUndo)
            .accessibilityLabel("直前の入れ替えを1手戻す")

            NavigationLink {
                LargeBoardView(viewModel: viewModel)
            } label: {
                Label("大画面表示", systemImage: "display")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("参加者向け大画面ボードを表示")

            if let csvText = viewModel.currentRoundCSV {
                ShareLink(
                    item: csvText,
                    subject: Text("\(viewModel.session.name) ラウンドCSV"),
                    message: Text("現在ラウンドの組み合わせCSVです。")
                ) {
                    Label("CSV共有", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .accessibilityLabel("現在ラウンドをCSVで共有")
            }

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
        .accessibilityElement(children: .contain)
        .accessibilityLabel(matchAccessibilityLabel(match))
    }

    private func teamColumn(title: String, players: [Participant]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("チーム\(title)")
                .font(.caption)
                .foregroundStyle(.secondary)
            ForEach(players) { player in
                playerRowForMatch(player)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func playerRowForMatch(_ player: Participant) -> some View {
        HStack(spacing: 6) {
            Text(player.displayName)
                .font(.title3.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            if let waitingParticipants = viewModel.currentRound?.waitingParticipants, !waitingParticipants.isEmpty {
                Menu {
                    ForEach(waitingParticipants) { waitingParticipant in
                        Button {
                            viewModel.replaceCurrentRoundPlayer(
                                playerID: player.id,
                                with: waitingParticipant.id
                            )
                        } label: {
                            Label(
                                "\(waitingParticipant.displayName)と交代",
                                systemImage: "arrow.left.arrow.right"
                            )
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left.arrow.right.circle")
                        .imageScale(.medium)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("\(player.displayName)を待機者と交代")
            }
        }
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
