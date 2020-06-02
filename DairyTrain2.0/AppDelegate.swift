import UIKit
//import Firebase
//import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   // static let dataBase = Database.database().reference()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setDefaultColorTheme()
        AppAuthentication.shared.initAuth()
        UINavigationBar.appearance().tintColor = .red
        return true
    }
    
    func setDefaultColorTheme() {
        if userDefaults.value(forKey: UserColorThemeKey) == nil ||
            userDefaults.value(forKey: UserWeighMetricKey) == nil ||
            userDefaults.value(forKey: UserHeightMetricKey) == nil {
            userDefaults.set(true, forKey: UserWeighMetricKey)
            userDefaults.set(true, forKey: UserColorThemeKey)
            userDefaults.set(true, forKey: UserHeightMetricKey)
        }
        
        print(ColorSetting.shared.themeColor)
        print(MeteringSetting.shared.weightMode)
        print(MeteringSetting.shared.heightMode)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return AppAuthentication.shared.handle(url: url)
      //  return GIDSignIn.sharedInstance().handle(url)
    }


}

