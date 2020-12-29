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
        
}

//MARK: - ProfileRouterOutputt
extension ProfileRouter: ProfileRouterOutputt {
    
    func presentLoginViewController() {
        MainCoordinator.shared.coordinate(to: AuthorizationCoordinator.Target.authorizationScreen)
        //MainCoordinator.shared.coordinate(to: MainCoordinator.Target.loginFlow)
    }
    
    func pushViewControllerFromMenu(_ viewController: UIViewController) {
        self.rootViewController?.navigationController?.pushViewController(viewController,
                                                                          animated: true)
    }
    
    func showMenuController() {

    }
}
