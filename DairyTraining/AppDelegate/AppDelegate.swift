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
        GoogleAuthorizationManager.shared.initAuth()
    }
    
    func setRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let splashScreenViewController = SplashScreenViewController()
        let onboardingFlow = OnboardingConfigurator.configureOnboardingFlow()
        
        guard UserDefaults.standard.isFirstSession else {
            window?.rootViewController = splashScreenViewController
            return
        }
        
        UserDefaults.standard.setFirstSession()
        window?.rootViewController = onboardingFlow
    }
}
