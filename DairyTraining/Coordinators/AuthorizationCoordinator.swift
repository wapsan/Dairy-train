import UIKit

final class AuthorizationCoordinator: Coordinator {

    // MARK: - Inner types
    enum Target: CoordinatorTarget {
        case splashScreen
        case authorizationScreen
    }

    // MARK: - Properties
    private lazy var transtitionOption: UIWindow.TransitionOptions = {
        var transitionOption = UIWindow.TransitionOptions(direction: .toRight, style: .linear)
        transitionOption.background = UIWindow.TransitionOptions.Background.solidColor(DTColors.backgroundColor)
        return transitionOption
    }()
    
    var window: UIWindow?

    private var rootTabBarController: UITabBarController?
    private var rootNavigationController: UINavigationController?
    private var childCoordinators: [Coordinator] = []

    init(rootViewController: UINavigationController) {
        self.rootNavigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }
 
    // MARK: - Coordinator API
    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch  target {
        case .splashScreen:
            let splashScreen = DTSplashScreenViewController()
            window?.rootViewController = splashScreen
        case .authorizationScreen:
            let authViewController = AuthorizationConfigurator.configureAuthorizationViewController()
            window?.setRootViewController(authViewController, options: transtitionOption)
        }
        return true
    }
}
