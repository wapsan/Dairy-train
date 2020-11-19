import UIKit

protocol LoginRouterOutput: AnyObject {
    func showMainFlow()
}

class LoginRouter: Router {
    
    //MARK: - Private properties
    //private weak var rootViewController: LoginViewController?
    
    //MARK: - Initialization
    required init(_ viewController: UIViewController) {
       // self.rootViewController = viewController as? LoginViewController
    }
}

//MARK: - LoginRouterOutput
extension LoginRouter: LoginRouterOutput {
    
    func showMainFlow() {
        MainCoordinator.shared.coordinate(to: MainCoordinator.Target.mainFlow)
    }
}
