import Foundation

final class MainTabBarConfigurator {
    
    static func cinfigure() -> MainTabBarViewController {
        let mainTabBarModel = MainTabBarModel()
        let mainTabBarViewModel = MainTabBarPresenter(model: mainTabBarModel)
        let mainTabBarViewController = MainTabBarViewController(viewModel: mainTabBarViewModel)
        let mainTabBarRouter = MainTabBarRouter(mainTabBarViewController)
        mainTabBarViewModel.view = mainTabBarViewController
        mainTabBarViewModel.router = mainTabBarRouter
        return mainTabBarViewController
    }
}
