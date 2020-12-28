import UIKit

final class AuthorizationCoordinator: Coordinator {


    
    // MARK: - Inner types
    enum Target: CoordinatorTarget {
        case splashScreen
        case authorizationScreen
    }

    // MARK: - Properties

    
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
            let authViewController = AuthorizationViewController()
            let loginViewModel = LoginViewModel()
            let loginModel = LoginModel()
            
            authViewController.viewModel = loginViewModel
            loginViewModel.view = authViewController
            loginViewModel.model = loginModel
            loginModel.output = loginViewModel
            var transitionOption = UIWindow.TransitionOptions(direction: .toRight, style: .linear)
            transitionOption.background = UIWindow.TransitionOptions.Background.solidColor(DTColors.backgroundColor)
            window?.setRootViewController(authViewController, options: transitionOption)
        }
        return true
    }
    
    @discardableResult func coordinateChild(to target: CoordinatorTarget) -> Bool {
          for coordinator in childCoordinators {
              if coordinator.coordinate(to: target) { return true }
          }
          
          return false
      }

}
