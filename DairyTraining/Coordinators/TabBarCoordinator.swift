import UIKit

final class TabBarCoordinator: Coordinator {


    
    // MARK: - Inner types
    enum Target: CoordinatorTarget {
        case mainTabBar
      //  case home
        case nutrition
        case trainingList
        case profile
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
        switch target {
        case .nutrition:
            rootTabBarController?.selectedIndex = 0
        case .trainingList:
            rootTabBarController?.selectedIndex = 1
        case .profile:
            rootTabBarController?.selectedIndex = 2
        case .mainTabBar:
            let mainFlow = MainTabBarConfigurator.cinfigure()
            rootTabBarController = mainFlow
            guard let a = rootTabBarController else { return false }
            window?.setRootViewController(a)
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
