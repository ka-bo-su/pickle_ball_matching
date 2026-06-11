import PickleBallMatchingCore
import SwiftUI

struct CurrentRoundSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel
    let showsScoreControls: Bool

    init(viewModel: OperationBoardViewModel, showsScoreControls: Bool = true) {
        self.viewModel = viewModel
        self.showsScoreControls = showsScoreControls
    }

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
                        .font(.title3.weight(.bold))
                    Text(waitingNames)
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 8)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("待機者 \(waitingNames)")
            }
        }
    }

    private func matchRow(_ match: Match) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("コート\(match.courtNumber)", systemImage: "sportscourt")
                .font(.title2.weight(.bold))

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    teamColumn(title: "A", players: match.teamA.players)
                    versusLabel
                    teamColumn(title: "B", players: match.teamB.players)
                }

                VStack(alignment: .leading, spacing: 12) {
                    teamColumn(title: "A", players: match.teamA.players)
                    versusLabel
                    teamColumn(title: "B", players: match.teamB.players)
                }
            }

            if showsScoreControls {
                scoreControls(for: match)
            }
        }
        .padding(.vertical, 10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(matchAccessibilityLabel(match))
    }

    private var versusLabel: some View {
        Text("vs")
            .font(.headline)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
            .accessibilityHidden(true)
    }

    private func teamColumn(title: String, players: [Participant]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("チーム\(title)")
                .font(.callout.weight(.semibold))
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
                .lineLimit(2)
                .minimumScaleFactor(0.8)

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
                Label("入替", systemImage: "arrow.left.arrow.right.circle")
                    .font(.callout.weight(.semibold))
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

        return VStack(alignment: .leading, spacing: 8) {
            Text("スコア")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.secondary)

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
