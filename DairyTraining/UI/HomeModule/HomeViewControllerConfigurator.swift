import UIKit

struct HomeViewControllerConfigurator {
    
    static func configureHomeNavigationControllet() -> UINavigationController {
        let homeModel = HomeModel()
        let homeViewModel = HomeViewModel(model: homeModel)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let homeViewModelRouter = HomeRouter(homeViewController)
        homeViewModel.router = homeViewModelRouter
        
        let navigattionController = UINavigationController(rootViewController: homeViewController)
        navigattionController.tabBarItem = DTTabBarItems.home.item
        return navigattionController
    }
}
