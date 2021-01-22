import UIKit

protocol Router {
    init(_ viewController: UIViewController)
    
    var mainTabBar: UITabBarController? { get }
    var topViewController: UIViewController? { get }
    var window: UIWindow? { get }
    
    func showExerciseFlow()
    func showPaternFlow()
    func showRedyWorkoutFlow()
}


extension Router {

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
    
    var mainTabBar: UITabBarController? {
        return UIApplication.topViewController()?.tabBarController
    }
    
    var window: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
}
