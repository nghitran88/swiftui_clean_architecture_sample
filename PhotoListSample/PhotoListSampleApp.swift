import SwiftUI

@main
struct PhotoListSampleApp: App {
    let coordinator: AppCoordinator
    
    init() {
        let diContainer = AppDIContainer()
        self.coordinator = AppCoordinator(diContainer: diContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
