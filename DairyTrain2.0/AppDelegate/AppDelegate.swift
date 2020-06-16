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
    
    func applicationWillResignActive(_ application: UIApplication) {
        DTFirebaseFileManager.shared.updateMainUserInfoInFirebase()
    }
}

