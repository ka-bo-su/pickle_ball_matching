import Combine
import Foundation
import PickleBallMatchingCore

@MainActor
final class MatchingViewModel: ObservableObject {
    @Published private(set) var state: MatchingViewState = .idle

    private let loadCandidatesUseCase: MatchCandidatesLoading
    private let currentPlayer: PlayerProfile

    init(loadCandidatesUseCase: MatchCandidatesLoading, currentPlayer: PlayerProfile) {
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
            state = .failed("候補を読み込めませんでした。あとでもう一度お試しください。")
        }
    }
}

protocol MatchCandidatesLoading: Sendable {
    func execute(for profile: PlayerProfile) async throws -> [MatchCandidate]
}

extension LoadMatchCandidatesUseCase: MatchCandidatesLoading {}

enum MatchingViewState: Equatable {
    case idle
    case loading
    case empty
    case loaded([MatchCandidate])
    case failed(String)
}
