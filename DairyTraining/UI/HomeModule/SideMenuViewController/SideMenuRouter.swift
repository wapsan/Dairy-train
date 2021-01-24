import UIKit

protocol SideMenuRouterProtocol {
    func showAuhorizationScreen()
    
    func showSettingScreen()
    func showTermsAndConditionsScreen()
    func showSignOutAlert(with completion: @escaping () -> Void)
    func showInfoAlert(with message: String)
}

protocol SideMenuRouterDelegate: AnyObject {
    func pushSettingScreen()
    func pushTermsAndConditionScreen()
}

final class SideMenuRouter: Router {
    
    private let rootViewController: UIViewController
    weak var delegate: SideMenuRouterDelegate?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension SideMenuRouter: SideMenuRouterProtocol {
    
    func showInfoAlert(with message: String) {
        showInfoAlert(title: message, message: nil, alertType: .alert, completion: nil)
    }
    
    func showSettingScreen() {
        delegate?.pushSettingScreen()
        rootViewController.dismiss(animated: true, completion: nil)
    }
    
    func showTermsAndConditionsScreen() {
        delegate?.pushTermsAndConditionScreen()
        rootViewController.dismiss(animated: true, completion: nil)
    }
    
    func showSignOutAlert(with completion: @escaping () -> Void) {
        showAlertWithCompletion(title: "Sign Out",
                        message: "Are you sure? All your not synhronized data will be deleted.",
                        alertType: .actionSheet,
                        completion: completion)
    }
    
    func showAuhorizationScreen() {
        let authorizationScreen = AuthorizationConfigurator.configureAuthorizationViewController()
        window?.setRootViewController(authorizationScreen)
    }
  
}
