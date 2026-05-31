import Foundation
import PickleBallMatchingCore

struct DependencyContainer {
    let currentPlayer: PlayerProfile
    let loadMatchCandidatesUseCase: LoadMatchCandidatesUseCase

    static func live() -> DependencyContainer {
        let currentPlayer = PlayerProfile(
            displayName: "You",
            skillLevel: .recreational,
            preferredPlayStyle: .casual,
            locationName: "Tokyo"
        )
        let repository = InMemoryMatchingRepository()
        return DependencyContainer(
            currentPlayer: currentPlayer,
            loadMatchCandidatesUseCase: LoadMatchCandidatesUseCase(repository: repository)
        )
    }
}
