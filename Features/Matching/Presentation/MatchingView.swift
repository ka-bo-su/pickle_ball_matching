import PickleBallMatchingCore
import SwiftUI

struct MatchingView: View {
    @StateObject private var viewModel: MatchingViewModel

    init(viewModel: MatchingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("候補")
                .task {
                    await viewModel.onAppear()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .accessibilityLabel("マッチ候補を読み込み中")
        case .empty:
            ContentUnavailableView("候補がまだありません", systemImage: "person.2.slash")
                .accessibilityLabel("マッチ候補がまだありません")
        case let .failed(message):
            ContentUnavailableView(message, systemImage: "exclamationmark.triangle")
                .accessibilityLabel(message)
        case let .loaded(candidates):
            List(candidates) { candidate in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(candidate.player.displayName)
                            .font(.headline)
                        Spacer()
                        Text("\(candidate.compatibilityScore)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .accessibilityLabel("相性スコア \(candidate.compatibilityScore)")
                    }
                    Text(candidate.reason)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(
                    "\(candidate.player.displayName)、相性スコア \(candidate.compatibilityScore)、\(candidate.reason)"
                )
            }
            .accessibilityLabel("マッチ候補一覧")
        }
    }
}

#Preview {
    let player = PlayerProfile(
        displayName: "Preview",
        skillLevel: .recreational,
        preferredPlayStyle: .casual,
        locationName: "Tokyo"
    )
    let useCase = LoadMatchCandidatesUseCase(repository: InMemoryMatchingRepository())
    MatchingView(viewModel: MatchingViewModel(loadCandidatesUseCase: useCase, currentPlayer: player))
}
