import UIKit

final class HomeViewControllerConfigurator {
    
    static func configureHomeNavigationControllet() -> UINavigationController {
        let homeModel = HomeModel()
        let homeViewModel = HomeViewModel(model: homeModel)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let homeViewModelRouter = HomeRouter(homeViewController)
        homeViewModel.router = homeViewModelRouter
        
        let navigattionController = UINavigationController(rootViewController: homeViewController)
        navigattionController.tabBarItem = MainTabBarModel.Item.home.item
        return navigattionController
    }
}
