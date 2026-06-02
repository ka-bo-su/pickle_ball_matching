import SwiftUI

struct RoundHistorySection: View {
    @ObservedObject var viewModel: OperationBoardViewModel

    var body: some View {
        let model = viewModel.roundHistoryDisplayModel

        Section("ラウンド履歴") {
            if model.isEmpty {
                ContentUnavailableView("履歴はまだありません", systemImage: "clock.arrow.circlepath")
                    .accessibilityLabel("ラウンド履歴はまだありません")
            } else {
                ForEach(model.rounds) { round in
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(round.matches) { match in
                                matchHistoryRow(match)
                            }

                            Label(round.waitingSummary, systemImage: "person.2.slash")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Label(round.title, systemImage: "clock")
                                    .font(.subheadline.weight(.semibold))

                                Spacer()

                                Text(round.statusText)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }

                            Text(round.waitingSummary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(round.accessibilityLabel)
                }
            }
        }
    }

    private func matchHistoryRow(_ match: RoundHistoryMatchDisplay) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(match.courtTitle, systemImage: "sportscourt")
                .font(.caption.weight(.semibold))

            Text(match.teamASummary)
                .font(.subheadline)
            Text(match.teamBSummary)
                .font(.subheadline)

            VStack(alignment: .leading, spacing: 4) {
                Label(match.scoreSummary, systemImage: "number")
                Label(match.winnerSummary, systemImage: "flag.checkered")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(match.accessibilityLabel)
    }
}
