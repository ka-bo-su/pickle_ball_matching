@testable import PickleBallMatching
import PickleBallMatchingCore
import XCTest

@MainActor
final class MatchingViewModelTests: XCTestCase {
    func testOnAppearTransitionsFromIdleToLoadingThenLoaded() async {
        let loader = DelayedMatchCandidatesLoader(candidates: [makeCandidate(name: "佐藤")])
        let viewModel = makeViewModel(loader: loader)

        let task = Task {
            await viewModel.onAppear()
        }

        try? await Task.sleep(nanoseconds: 10_000_000)
        XCTAssertEqual(viewModel.state, .loading)

        await task.value

        XCTAssertEqual(viewModel.state, .loaded([makeCandidate(name: "佐藤")]))
    }

    func testOnAppearTransitionsToEmptyWhenNoCandidatesExist() async {
        let viewModel = makeViewModel(loader: ImmediateMatchCandidatesLoader(result: .success([])))

        await viewModel.onAppear()

        XCTAssertEqual(viewModel.state, .empty)
    }

    func testOnAppearTransitionsToFailedWhenLoaderThrows() async {
        let viewModel = makeViewModel(loader: ImmediateMatchCandidatesLoader(result: .failure(TestError.failed)))

        await viewModel.onAppear()

        XCTAssertEqual(viewModel.state, .failed("候補を読み込めませんでした。あとでもう一度お試しください。"))
    }

    func testOnAppearDoesNotReloadAfterInitialLoad() async {
        let loader = CountingMatchCandidatesLoader()
        let viewModel = makeViewModel(loader: loader)

        await viewModel.onAppear()
        await viewModel.onAppear()

        XCTAssertEqual(loader.callCount, 1)
        XCTAssertEqual(viewModel.state, .loaded([makeCandidate(name: "高橋")]))
    }

    private func makeViewModel(loader: MatchCandidatesLoading) -> MatchingViewModel {
        MatchingViewModel(
            loadCandidatesUseCase: loader,
            currentPlayer: PlayerProfile(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000100")!,
                displayName: "幹事",
                skillLevel: .recreational,
                preferredPlayStyle: .casual,
                locationName: "東京"
            )
        )
    }

    private func makeCandidate(name: String) -> MatchCandidate {
        MatchCandidate(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            player: PlayerProfile(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                displayName: name,
                skillLevel: .recreational,
                preferredPlayStyle: .casual,
                locationName: "東京"
            ),
            compatibilityScore: 90,
            reason: "レベルと場所が近い候補です"
        )
    }
}

private enum TestError: Error {
    case failed
}

private final class ImmediateMatchCandidatesLoader: MatchCandidatesLoading, @unchecked Sendable {
    private let result: Result<[MatchCandidate], Error>

    init(result: Result<[MatchCandidate], Error>) {
        self.result = result
    }

    func execute(for _: PlayerProfile) async throws -> [MatchCandidate] {
        try result.get()
    }
}

private final class DelayedMatchCandidatesLoader: MatchCandidatesLoading, @unchecked Sendable {
    private let candidates: [MatchCandidate]

    init(candidates: [MatchCandidate]) {
        self.candidates = candidates
    }

    func execute(for _: PlayerProfile) async throws -> [MatchCandidate] {
        try await Task.sleep(nanoseconds: 50_000_000)
        return candidates
    }
}

private final class CountingMatchCandidatesLoader: MatchCandidatesLoading, @unchecked Sendable {
    private(set) var callCount = 0

    func execute(for _: PlayerProfile) async throws -> [MatchCandidate] {
        callCount += 1
        return [
            MatchCandidate(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                player: PlayerProfile(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                    displayName: "高橋",
                    skillLevel: .recreational,
                    preferredPlayStyle: .casual,
                    locationName: "東京"
                ),
                compatibilityScore: 90,
                reason: "レベルと場所が近い候補です"
            )
        ]
    }
}
