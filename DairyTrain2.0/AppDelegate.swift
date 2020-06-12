import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DTSettingManager.shared.activateDefaultSetting()
        AppAuthentication.shared.initAuth()
        self.initStartViewController()
        UINavigationBar.appearance().tintColor = .red
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return AppAuthentication.shared.handle(url: url)
    }
    
    //MARK: - Private methods
    func initStartViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return }
        if let userToken = DTSettingManager.shared.getUserToken() {
            print("User token - \(userToken).")
            window.rootViewController = MainTabBarVC()
        } else {
            print("User token - nill.")
            window.rootViewController = MainLoginVC()
        }
        window.makeKeyAndVisible()
    }
}

