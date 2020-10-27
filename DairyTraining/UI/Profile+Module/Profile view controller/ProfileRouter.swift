import UIKit

protocol ProfileRouterOutputt: AnyObject {
    func presentLoginViewController()
    func pushViewControllerFromMenu(_ viewController: UIViewController)
    func showMenuController()
}

final class ProfileRouter: Router {
    
    private weak var rootViewController: ProfileViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? ProfileViewController
    }
        
    private func configureMenuController() -> MenuViewController {
        let menuStackViewController = MenuViewController()
        menuStackViewController.modalPresentationStyle = .custom
        menuStackViewController.transitioningDelegate = self.rootViewController 
        menuStackViewController.delegate = self.rootViewController?.viewModel 
        return menuStackViewController
    }
}

//MARK: - ProfileRouterOutputt
extension ProfileRouter: ProfileRouterOutputt {
    
    func presentLoginViewController() {
        MainCoordinator.shared.coordinate(to: MainCoordinator.Target.loginFlow)
    }
    
    func pushViewControllerFromMenu(_ viewController: UIViewController) {
        self.rootViewController?.navigationController?.pushViewController(viewController,
                                                                          animated: true)
    }
    
    func showMenuController() {
        let menuVC = self.configureMenuController()
        self.rootViewController?.present(menuVC, animated: true, completion: nil)
    }
}
