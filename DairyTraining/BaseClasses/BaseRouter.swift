import UIKit

class BaseRouter {
    
    //MARK: - Internal propeties
    weak var rootViewController: UIViewController?
    
    //MARK: - Initialization
    init(viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

//MARK: - Extension BaseRouter
extension BaseRouter {
    
    var tabBarController: UITabBarController? {
        return rootViewController?.tabBarController
    }
    
    var navigationController: UINavigationController? {
        return rootViewController?.navigationController
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        rootViewController?.present(viewController, animated: animated, completion: completion)
    }
}
