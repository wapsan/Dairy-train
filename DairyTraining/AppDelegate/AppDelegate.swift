import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Window propertie
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DTSettingManager.shared.activateDefaultSetting()
        GoogleAuthorizationManager.shared.initAuth()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = DTColors.backgroundColor
        MainCoordinator.shared.window = self.window
        MainCoordinator.shared.coordinate(to: MainCoordinator.Target.splashScreen)
        UINavigationBar.appearance().tintColor = .white
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GoogleAuthorizationManager.shared.handle(url: url)
    }
}
