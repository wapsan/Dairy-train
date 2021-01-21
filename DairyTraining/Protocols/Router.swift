import UIKit

protocol Router {
    init(_ viewController: UIViewController)

    var mainTabBar: UITabBarController? { get }
    var window: UIWindow? { get }
}


extension Router {

 
    var mainTabBar: UITabBarController? {
        return UIApplication.topViewController()?.tabBarController
    }
    
    var window: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
}
