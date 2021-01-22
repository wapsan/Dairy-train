import UIKit

protocol AuthorizationRouterProtocol: AnyObject {
    func setMainTabBarToRootViewController()
}

final class AuthorizationRouter: Router {
    
    // MARK: - Properties
    private let rootViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - AuthorizationRouterProtocol
extension AuthorizationRouter: AuthorizationRouterProtocol {
    
    func setMainTabBarToRootViewController() {
        let mainTabBar = MainTabBarConfigurator.cinfigure()
        window?.rootViewController = mainTabBar
    }
}
