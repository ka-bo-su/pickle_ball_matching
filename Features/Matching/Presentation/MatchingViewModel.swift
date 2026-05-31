import Combine
import Foundation
import PickleBallMatchingCore

@MainActor
final class MatchingViewModel: ObservableObject {
    @Published private(set) var state: MatchingViewState = .idle

    private let loadCandidatesUseCase: LoadMatchCandidatesUseCase
    private let currentPlayer: PlayerProfile

    init(loadCandidatesUseCase: LoadMatchCandidatesUseCase, currentPlayer: PlayerProfile) {
        self.loadCandidatesUseCase = loadCandidatesUseCase
        self.currentPlayer = currentPlayer
    }

    func onAppear() async {
        guard case .idle = state else {
            return
        }

        state = .loading
        do {
            let candidates = try await loadCandidatesUseCase.execute(for: currentPlayer)
            state = candidates.isEmpty ? .empty : .loaded(candidates)
        } catch {
            state = .failed("Could not load matches. Try again later.")
        }
    }
}

enum MatchingViewState: Equatable {
    case idle
    case loading
    case empty
    case loaded([MatchCandidate])
    case failed(String)
}
