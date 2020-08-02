import UIKit

protocol LoginRouterOutput: AnyObject {
    func showMainFlow()
}

class LoginRouter: Router {
    
    //MARK: - Private properties
    private weak var rootViewController: LoginViewController?
    
    //MARK: - Initialization
    required init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? LoginViewController
    }
    
    //MARK: - Private methods
    private func configureMainFlowController() -> MainTabBarViewController {
        let mainFlowViewController = MainTabBarViewController()
        return mainFlowViewController
    }
}

//MARK: - LoginRouterOutput
extension LoginRouter: LoginRouterOutput {
    
    func showMainFlow() {
        let mainFlow = self.configureMainFlowController()
        mainFlow.modalPresentationStyle = .fullScreen
        self.rootViewController?.present(mainFlow, animated: true, completion: nil)
    }
}
