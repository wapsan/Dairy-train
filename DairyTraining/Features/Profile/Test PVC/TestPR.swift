import UIKit

protocol ProfileRouterOutputt: AnyObject {
    func presentLoginViewController()
    func pushViewControllerFromMenu(_ viewController: UIViewController)
    func showMenuController()
}

final class TestPR: Router {
    
    private weak var rootViewController: TestPVC?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? TestPVC
    }
    
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
        menuStackViewController.delegate = self.rootViewController?.viewModel 
        return menuStackViewController
    }
}

extension TestPR: ProfileRouterOutputt {
    
    func presentLoginViewController() {
        let loginVC = self.configureLoginViewController()
               loginVC.modalPresentationStyle = .overFullScreen
               self.rootViewController?.present(loginVC, animated: true, completion: nil)
    }
    
    func pushViewControllerFromMenu(_ viewController: UIViewController) {
          self.rootViewController?.navigationController?.pushViewController(viewController,
                                                                                animated: true)
    }
    
    func showMenuController() {
        let menuVC = self.configureMenuController()
        self.rootViewController?.present(menuVC, animated: true, completion: nil)
    }
}
