import UIKit

extension AppDelegate {
    
    //MARK: - Public methods
    func initStartViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return }
        window.backgroundColor = DTColors.backgroundColor
        let navigationController = UINavigationController(rootViewController: DTSplashScreenViewController())
        if let userToken = DTSettingManager.shared.getUserToken() {
            print("User token - \(userToken).")
            window.rootViewController = navigationController
        } else {
            print("User token - nill.")
            window.rootViewController = self.configureLoginViewController()
        }
        window.makeKeyAndVisible()
    }
    
    func configureLoginViewController() -> LoginViewController {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel()
        let loginModel = LoginModel()
        let loginRouter = LoginRouter(loginViewController)
        
        loginViewController.viewModel = loginViewModel
        loginViewController.router = loginRouter
        loginViewModel.view = loginViewController
        loginViewModel.model = loginModel
        loginModel.output = loginViewModel
        return loginViewController
    }
}
