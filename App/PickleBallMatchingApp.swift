import SwiftUI

@main
struct PickleBallMatchingApp: App {
    private let container = DependencyContainer.live()

    var body: some Scene {
        WindowGroup {
            TabView {
                ProfileView(viewModel: container.profileViewModel)
                    .tabItem {
                        Label("マイプロフィール", systemImage: "person.crop.circle")
                    }
                OperationBoardView(viewModel: container.operationBoardViewModel)
                    .tabItem {
                        Label("運営ボード", systemImage: "list.clipboard")
                    }
            }
        }
    }
}
