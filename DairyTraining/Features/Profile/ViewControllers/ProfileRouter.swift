import UIKit

protocol Router {

    init(_ viewController: UIViewController)
}

protocol ProfileRouterOutput: AnyObject {
    func presentLoginViewController()
    func pushViewControllerFromMenu(_ viewController: UIViewController)
    func showMenuController()
}

class ProfileRouter: Router {
  
    //MARK: - Private properties
    private weak var rootViewController: ProfileViewController?
    
    //MARK: - Initialization
    required init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? ProfileViewController
    }
    
    //MARK: - Private methods
    private func configureLoginViewController() -> LoginViewController {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel()
        let loginModel = LoginModel()
        let loginRouter = LoginRouter(loginViewController)
        
        loginViewController.router = loginRouter
        loginViewController.viewModel = loginViewModel
        loginViewModel.view = loginViewController
        loginViewModel.model = loginModel
        loginModel.output = loginViewModel
        return loginViewController
    }
    
    private func configureMenuController() -> MenuViewController {
        let menuStackViewController = MenuViewController()
        menuStackViewController.modalPresentationStyle = .custom
        menuStackViewController.transitioningDelegate = self.rootViewController
        menuStackViewController.delegate = self.rootViewController?.viewModel as? MenuControllerDelegate
        return menuStackViewController
    }
}

//MARK: - ProfileModelOutput
extension ProfileRouter: ProfileRouterOutput {
    
    func showMenuController() {
        let menuVC = self.configureMenuController()
        self.rootViewController?.present(menuVC, animated: true, completion: nil)
    }
    
    func pushViewControllerFromMenu(_ viewController: UIViewController) {
        self.rootViewController?.navigationController?.pushViewController(viewController,
                                                                          animated: true)
    }
    
    func presentLoginViewController() {
        let loginVC = self.configureLoginViewController()
        loginVC.modalPresentationStyle = .overFullScreen
        self.rootViewController?.present(loginVC, animated: true, completion: nil)
    }
}
