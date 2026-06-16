import SwiftUI

struct RoundTimingSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel

    var body: some View {
        if viewModel.currentRound != nil {
            Section("ラウンド進行") {
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    if let timing = viewModel.currentRoundTimingModel(now: context.date) {
                        timingContent(timing)
                    }
                }
            }
        }
    }

    private func timingContent(_ timing: OperationBoardRoundTimingModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            header(timing)

            Text(timing.detailText)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            controls(timing)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(timing.accessibilityLabel)
    }

    private func header(_ timing: OperationBoardRoundTimingModel) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Label(timing.statusTitle, systemImage: "timer")
                .font(.headline)
            Spacer()
            Text(timing.remainingTimeText)
                .font(.system(.title, design: .monospaced).weight(.bold))
                .accessibilityLabel("残り時間 \(timing.remainingTimeText)")
        }
    }

    private func controls(_ timing: OperationBoardRoundTimingModel) -> some View {
        HStack(spacing: 12) {
            Button {
                viewModel.startCurrentRound()
            } label: {
                Label("試合開始", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!timing.canStart)
            .accessibilityLabel("現在ラウンドの試合を開始")

            Button {
                viewModel.finishCurrentRound()
            } label: {
                Label("ラウンド終了", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .disabled(!timing.canFinish)
            .accessibilityLabel("現在ラウンドを終了")
        }
    }
}
