import UIKit

protocol OnboardingRouterProtocol {
    func showAuthorizationScreen()
}

final class OnboardingRouter: Router {
    
    //MARK: - Properties
    private let rootViewController: UIViewController
    
    //MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

//MARK: - OnboardingRouterProtocol
extension OnboardingRouter: OnboardingRouterProtocol {
    
    func showAuthorizationScreen() {
        let authorizationScreen = AuthorizationConfigurator.configureAuthorizationViewController()
        self.rootViewController.navigationController?.pushViewController(authorizationScreen, animated: true)
    }
}
