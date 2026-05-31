import SwiftUI

@main
struct PickleBallMatchingApp: App {
    private let container = DependencyContainer.live()

    var body: some Scene {
        WindowGroup {
            OperationBoardView(viewModel: container.operationBoardViewModel)
        }
    }
}
