import PickleBallMatchingCore
import SwiftUI

struct CurrentRoundSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel

    var body: some View {
        if let round = viewModel.currentRound {
            Section("ラウンド\(round.number)") {
                ForEach(round.matches) { match in
                    matchRow(match)
                }

                waitingParticipantsView(round)
            }
        } else {
            Section("進行ボード") {
                ContentUnavailableView("まだラウンドがありません", systemImage: "list.bullet.rectangle")
                    .accessibilityLabel("まだラウンドがありません")
            }
        }
    }

    private func waitingParticipantsView(_ round: Round) -> some View {
        let waitingNames = round.waitingParticipants.map(\.displayName).joined(separator: "、")

        return Group {
            if !round.waitingParticipants.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Label("待機", systemImage: "person.2.slash")
                        .font(.headline)
                    Text(waitingNames)
                        .font(.body)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("待機者 \(waitingNames)")
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

            scoreControls(for: match)
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

            playerSwapMenu(player)
        }
    }

    @ViewBuilder
    private func playerSwapMenu(_ player: Participant) -> some View {
        let swapCandidates = viewModel.swapCandidates(for: player.id)

        if !swapCandidates.isEmpty {
            Menu {
                ForEach(swapCandidates) { candidate in
                    Button {
                        viewModel.swapCurrentRoundParticipants(
                            firstID: player.id,
                            secondID: candidate.id
                        )
                    } label: {
                        Label(
                            "\(candidate.displayName)と入れ替え",
                            systemImage: "arrow.left.arrow.right"
                        )
                    }
                }
            } label: {
                Image(systemName: "arrow.left.arrow.right.circle")
                    .imageScale(.medium)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("\(player.displayName)をラウンド内の参加者と入れ替え")
        }
    }

    private func matchAccessibilityLabel(_ match: Match) -> String {
        let teamA = match.teamA.players.map(\.displayName).joined(separator: "、")
        let teamB = match.teamB.players.map(\.displayName).joined(separator: "、")
        let score = viewModel.score(for: match.id)
        let scoreText = "スコア チームA \(score.teamAScore)、チームB \(score.teamBScore)"
        return "コート\(match.courtNumber)、\(teamA) 対 \(teamB)、\(scoreText)、結果 \(viewModel.winnerText(for: match.id))"
    }

    private func scoreControls(for match: Match) -> some View {
        let score = viewModel.score(for: match.id)

        return DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                Stepper(value: teamAScoreBinding(for: match.id), in: 0 ... 99) {
                    Label("チームA \(score.teamAScore)", systemImage: "a.circle")
                }
                .accessibilityLabel("チームAのスコア \(score.teamAScore)")

                Stepper(value: teamBScoreBinding(for: match.id), in: 0 ... 99) {
                    Label("チームB \(score.teamBScore)", systemImage: "b.circle")
                }
                .accessibilityLabel("チームBのスコア \(score.teamBScore)")

                Label(viewModel.winnerText(for: match.id), systemImage: "flag.checkered")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("試合結果 \(viewModel.winnerText(for: match.id))")
            }
        } label: {
            Label("スコア", systemImage: "number.circle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    private func teamAScoreBinding(for matchID: Match.ID) -> Binding<Int> {
        Binding(
            get: { viewModel.score(for: matchID).teamAScore },
            set: { newValue in
                let score = viewModel.score(for: matchID)
                viewModel.updateCurrentRoundMatchScore(
                    matchID: matchID,
                    teamAScore: newValue,
                    teamBScore: score.teamBScore
                )
            }
        )
    }

    private func teamBScoreBinding(for matchID: Match.ID) -> Binding<Int> {
        Binding(
            get: { viewModel.score(for: matchID).teamBScore },
            set: { newValue in
                let score = viewModel.score(for: matchID)
                viewModel.updateCurrentRoundMatchScore(
                    matchID: matchID,
                    teamAScore: score.teamAScore,
                    teamBScore: newValue
                )
            }
        )
    }
}
