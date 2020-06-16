import CoreData
import UIKit

extension AppDelegate {
    
    //MARK: - Properties
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Public methods
    func initStartViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return }
        if let userToken = DTSettingManager.shared.getUserToken() {
            print("User token - \(userToken).")
            window.rootViewController = MainTabBarViewController()
        } else {
            print("User token - nill.")
            window.rootViewController = LoginViewController()
        }
        window.makeKeyAndVisible()
    }
}
