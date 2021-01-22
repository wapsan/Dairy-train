import UIKit

protocol SideMenuRouterProtocol {
    func showScreen(for sideMenuItem: SideMenuModel.MenuItem)
    func showAuhorizationScreen()
}

protocol SideMenuRouterDelegate: AnyObject {
    func pushSettingScreen()
    func pushTermsAndConditionScreen()
}

protocol SideMenuRouterOutput: AnyObject {
    func signOut()
}

final class SideMenuRouter: Router {
    
    private let rootViewController: UIViewController
    weak var delegate: SideMenuRouterDelegate?
    weak var output: SideMenuRouterOutput?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension SideMenuRouter: SideMenuRouterProtocol {
    
    func showAuhorizationScreen() {
        let authorizationScreen = AuthorizationConfigurator.configureAuthorizationViewController()
        window?.setRootViewController(authorizationScreen)
    }
    
    func showScreen(for sideMenuItem: SideMenuModel.MenuItem) {
        switch sideMenuItem {
        case .premium:
            break
        case .setting:
            delegate?.pushSettingScreen()
            rootViewController.dismiss(animated: true, completion: nil)
        case .termAndConditions:
            delegate?.pushTermsAndConditionScreen()
            rootViewController.dismiss(animated: true, completion: nil)
        case .logOut:
            rootViewController.showDefaultAlert(title: "Sign out",
                                                message: "Are you sure? If you logout all your not synhronized data will be deleted.",
                                                preffedStyle: .actionSheet,
                                                okTitle: "Ok",
                                                cancelTitle: "Cance",
                                                completion: { [weak self] in
                                                    self?.output?.signOut()
            })
        }
    }
}
