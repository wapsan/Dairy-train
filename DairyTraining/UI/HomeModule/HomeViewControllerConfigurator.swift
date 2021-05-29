import UIKit

final class HomeViewControllerConfigurator {
    
    static func configureHomeNavigationControllet() -> UINavigationController {
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interactor: interactor)
        let viewController = HomeViewController(presenter: presenter)
        let router = HomeRouter(viewController: viewController)
        presenter.router = router
        
        let navigattionController = UINavigationController(rootViewController: viewController)
        navigattionController.tabBarItem = MainTabBarModel.Item.home.item
        return navigattionController
    }
}
