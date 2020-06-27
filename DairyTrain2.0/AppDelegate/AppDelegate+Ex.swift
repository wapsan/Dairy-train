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
           // window.rootViewController = MainTabBarViewController()
        } else {
            print("User token - nill.")
            window.rootViewController = LoginViewController()
        }
        window.makeKeyAndVisible()
    }
}
