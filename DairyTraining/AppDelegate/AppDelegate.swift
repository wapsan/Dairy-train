import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Window property
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applyAppSetting()
        setRootViewController()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GoogleAuthorizationManager.shared.handle(url: url)
    }
}

// MARK: - Private
private extension AppDelegate {
    
    func applyAppSetting() {
        SettingManager.shared.activateDefaultSetting()
        GoogleAuthorizationManager.shared.initAuth()
        guard !UserDataManager.shared.isSettingSaved() else { return }
        UserDataManager.shared.updateUserWeightMode(to: MeteringSetting.shared.weightMode)
        UserDataManager.shared.updateUserHeightMode(to: MeteringSetting.shared.heightMode)
    }
    
    func setRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = DTColors.backgroundColor
        MainCoordinator.shared.window = self.window
        MainCoordinator.shared.coordinate(to: AuthorizationCoordinator.Target.splashScreen)
        UINavigationBar.appearance().tintColor = .white
    }
}
