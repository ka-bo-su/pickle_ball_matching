import SwiftUI

@main
struct PickleBallMatchingApp: App {
    private let container = DependencyContainer.live()

    var body: some Scene {
        WindowGroup {
            MatchingView(
                viewModel: MatchingViewModel(
                    loadCandidatesUseCase: container.loadMatchCandidatesUseCase,
                    currentPlayer: container.currentPlayer
                )
            )
        }
    }
}
