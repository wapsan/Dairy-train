import UIKit

extension AppDelegate {
    
    //MARK: - Public methods
    func initStartViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return }
        let navigationController = UINavigationController(rootViewController: DTSplashScreenViewController())
        if let userToken = DTSettingManager.shared.getUserToken() {
            print("User token - \(userToken).")
            window.rootViewController = navigationController
        } else {
            print("User token - nill.")
            window.rootViewController = self.configureLoginViewController()//LoginViewController()
        }
        window.makeKeyAndVisible()
    }
    
    func configureLoginViewController() -> LoginViewController {
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel()
        let loginModel = LoginModel()
        loginViewController.viewModel = loginViewModel
        loginViewModel.viewPresenter = loginViewController
        loginViewModel.model = loginModel
        loginModel.delegate = loginViewModel
        return loginViewController
    }
}
