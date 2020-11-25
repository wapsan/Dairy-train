import Foundation
import CoreData

final class UserInfoManager {
    
    // MARK: - Singletone initialization
    static let shared = UserInfoManager()
    private init() {}
    
    // MARK: - Private properties
    private lazy var dataModelName = "UserMainInfo"
    
    private lazy var mainInfoContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var mainInfoContext: NSManagedObjectContext = {
        return self.mainInfoContainer.viewContext
    }()
    
    // MARK: - Private methods
    private func updateInfoContext() {
        if mainInfoContext.hasChanges {
            do {
                try mainInfoContext.save()
            } catch {
                print("MainInfoContext don't update")
            }
        }
    }
    
    
}
