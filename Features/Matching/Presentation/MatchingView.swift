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
                .navigationTitle("Matches")
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
                .accessibilityLabel("Loading match candidates")
        case .empty:
            ContentUnavailableView("No matches yet", systemImage: "person.2.slash")
        case let .failed(message):
            ContentUnavailableView(message, systemImage: "exclamationmark.triangle")
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
                            .accessibilityLabel("Compatibility score \(candidate.compatibilityScore)")
                    }
                    Text(candidate.reason)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
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
