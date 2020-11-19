import UIKit

protocol CoordinatorTarget {}

protocol Coordinator: class {
    @discardableResult func coordinate(to: CoordinatorTarget) -> Bool
    var window: UIWindow? { get set }
}

extension Coordinator {

    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard var topController = keyWindow?.rootViewController else {
            return nil
        }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    var topNavigationController: UINavigationController? {
        guard let topNavigationController = topViewController as? UINavigationController else {
            return topViewController?.navigationController
        }
        return topNavigationController
    }

    @discardableResult func pushViewController(_  controller: UIViewController, _ transition: CATransition? = nil) -> Bool {
        guard let topNavigationController = topNavigationController else {
            return false
        }
        guard type(of: controller) != type(of: topNavigationController.viewControllers.last) else {
            return false
        }
        if let transition = transition {
            topNavigationController.view.layer.add(transition, forKey: nil)
            topNavigationController.pushViewController(controller, animated: false)
        } else {
            topNavigationController.pushViewController(controller, animated: true)
        }
        return true
    }

    @discardableResult func popToRootViewController(_ transition: CATransition? = nil) -> Bool {
        guard let topNavigationController = topNavigationController else {
            return false
        }
        if let transition = transition {
            topNavigationController.view.layer.add(transition, forKey: nil)
            topNavigationController.popToRootViewController(animated: false)
        } else {
            topNavigationController.popToRootViewController(animated: true)
        }
        return true
    }

    @discardableResult func popViewController(_ transition: CATransition? = nil) -> Bool {
        guard let topNavigationController = topNavigationController else {
            return false
        }
        if let transition = transition {
            topNavigationController.view.layer.add(transition, forKey: nil)
            topNavigationController.popViewController(animated: false)
        } else {
            topNavigationController.popViewController(animated: true)
        }
        return true
    }

    var navigationBarIsHidden: Bool {
        get {
            guard let topNavigationController = topNavigationController else {
                return true
            }
            return topNavigationController.navigationBar.isHidden
        }
        set {
            guard let topNavigationController = topNavigationController else {
                return
            }
            topNavigationController.navigationBar.isHidden = newValue
        }
    }
}

final class MainCoordinator: Coordinator {

    // MARK: - Constants

    private struct Constants {
        static let statusBarEndAlpha: CGFloat = 0
        static let relativeMenuWidth: CGFloat = 0.70
        static let presentingEndAlpha: CGFloat = 0.4
    }
    
    // MARK: - Inner types

    enum Target: CoordinatorTarget {
        case splashScreen
        case mainFlow
        case loginFlow
    }

    // MARK: - Properties

    static let shared = MainCoordinator()

    var window: UIWindow? {
        didSet {
            childCoordinators = createChildCoordinators(for: window)
        }
    }

    private var rootTabBarController: UITabBarController?
    private var rootNavigationController: UINavigationController?
    private var childCoordinators: [Coordinator] = []

    private(set) var profileNavigationController: UINavigationController
    private(set) var trainingBlockNavigationController: UINavigationController
    private(set) var nutritionBlockNavigationController: UINavigationController
    
    // MARK: - Init

    private init() {
        self.profileNavigationController = TabBarItemController.profile.navigationController
        self.trainingBlockNavigationController = TabBarItemController.trainingBlock.navigationController
        self.nutritionBlockNavigationController = TabBarItemController.supplyBlock.navigationController
    }

    // MARK: - Coordinator API

    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        case .splashScreen:
            let splashScreen = DTSplashScreenViewController()
            window?.rootViewController = splashScreen
        case .mainFlow:
            let mainFlow = MainTabBarViewController()
            rootTabBarController = mainFlow
            guard let a = rootTabBarController else { return false }
            window?.setRootViewController(a)
        case .loginFlow:
           // let loginViewController = LoginViewController()
            let authViewController = AuthorizationViewController()
            let loginViewModel = LoginViewModel()
            let loginModel = LoginModel()
          //  let loginRouter = LoginRouter(authViewController)
            
            authViewController.viewModel = loginViewModel
           // authViewController.router = loginRouter
            loginViewModel.view = authViewController
            loginViewModel.model = loginModel
            loginModel.output = loginViewModel
            var transitionOption = UIWindow.TransitionOptions(direction: .toRight, style: .linear)
            transitionOption.background = UIWindow.TransitionOptions.Background.solidColor(DTColors.backgroundColor)
            window?.setRootViewController(authViewController, options: transitionOption)
        }
        return true
    }
    
    func setTabBarHidden(_ isHiden: Bool, duration: TimeInterval) {
        rootTabBarController?.tabBar.hide(isHiden, animated: true, duration: duration)
    }
    
    @discardableResult func coordinateChild(to target: CoordinatorTarget) -> Bool {
          for coordinator in childCoordinators {
              if coordinator.coordinate(to: target) { return true }
          }
          
          return false
      }

    // MARK: - Private

    private func createChildCoordinators(for window: UIWindow?) -> [Coordinator] {
        return [MuscleGroupsCoordinator(window: window),
                ProfileMenuCoordinator(rootViewController: self.profileNavigationController),
                TrainingModuleCoordinator(rootViewController: self.trainingBlockNavigationController)]
    }
}
