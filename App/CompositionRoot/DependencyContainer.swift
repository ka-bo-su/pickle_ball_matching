import Foundation
import PickleBallMatchingCore

@MainActor
struct DependencyContainer {
    let operationBoardViewModel: OperationBoardViewModel

    static func live() -> DependencyContainer {
        DependencyContainer(
            operationBoardViewModel: OperationBoardViewModel(
                generateNextRoundUseCase: GenerateNextRoundUseCase()
            )
        )
    }
}
