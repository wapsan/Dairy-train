import UIKit
import Firebase

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
        FirebaseApp.configure()
        SettingManager.shared.activateDefaultSetting()
        GoogleAuthorizationManager.shared.initAuth()
        guard !UserDataManager.shared.isSettingSaved() else { return }
        UserDataManager.shared.updateUserWeightMode(to: MeteringSetting.shared.weightMode)
        UserDataManager.shared.updateUserHeightMode(to: MeteringSetting.shared.heightMode)
    }
    
    func setRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let splashScreenViewController = SplashScreenViewController()
        let onboardingFlow = OnboardingConfigurator.configureOnboardingFlow()
        
        if SettingManager.shared.isFirstSession {
            SettingManager.shared.setFirstSessionStarted()
            window?.rootViewController = onboardingFlow
        } else {
            window?.rootViewController = splashScreenViewController
        }
    }
}
