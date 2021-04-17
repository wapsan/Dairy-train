import Foundation
import CoreData

protocol PersistenceServiceProtocol {
    
    var workout: WorkoutService2Protocol { get }
    
    var exercise: ExerciseServiceProtocol { get }
    
    var approaches: ApproachServiceProtocol { get }
    
    var user: UserServiceProtocol { get }
    
    var workoutTemplates: WorkoutTemplateServiceProtocol { get }
    
    var nutrition: NutritionServiceProtocol { get }
}

//MARK: - DataBase
final class DataBase {
    
    //MARK: - Static properties
    static let shared = DataBase()
    private static let workoutDataModelName = "WorkoutDataModel"
    private static let userDataModelName = "UserInfo"
    private static let nutritionDataModelName = "NutritionDataModel"
    
    //MARK: - Private properties
    private lazy var workoutProdContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataBase.workoutDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    private lazy var userInfoTestContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataBase.userDataModelName)
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    private lazy var userInfoProdContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataBase.userDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    private lazy var workoutTestContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataBase.workoutDataModelName)
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    private lazy var nutritionProdContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataBase.nutritionDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
    
    private lazy var nutritionTestContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DataBase.nutritionDataModelName)
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }()
   
    
    //MARK: - Publick methods
    func userInfoContext(type: PersistentStoreType) -> NSManagedObjectContext {
        switch type {
        case .prod:
            return userInfoProdContainer.viewContext
        case .test:
            return userInfoTestContainer.viewContext
        }
    }
    
    func workoutContext(type: PersistentStoreType) -> NSManagedObjectContext {
        switch type {
        case .prod:
            return workoutProdContainer.viewContext
        case .test:
            return workoutTestContainer.viewContext
        }
    }
    
    func nutritionContexttype(type: PersistentStoreType) -> NSManagedObjectContext {
        switch type {
        case .prod:
            return nutritionProdContainer.viewContext
        case .test:
            return nutritionTestContainer.viewContext
        }
    }
}

final class PersistenceService {
    
    //MARK: - Properies
    private let storeType: PersistentStoreType
    
    //MARK: - Initialization
    init(storeType: PersistentStoreType = .prod) {
        self.storeType = storeType
    }
    
    //MARK: - Private properties
    private lazy var workoutService = WorkoutService(storeType: storeType)
    private lazy var exerciseservice = ExerciseService(storeType: storeType)
    private lazy var approachService = ApproachService(storeType: storeType)
    private lazy var userService = UserInfoService(storeType: storeType)
    private lazy var workoutTemplateService = WorkoutTemplateService(storeType: storeType)
    private lazy var nutritionService = NutritionService(storeType: storeType)
}

//MARK: - PersistenceServiceProtocol
extension PersistenceService: PersistenceServiceProtocol {
    
    var nutrition: NutritionServiceProtocol {
        return nutritionService as NutritionServiceProtocol
    }
    
    var workout: WorkoutService2Protocol {
        return workoutService as WorkoutService2Protocol
    }
    
    var exercise: ExerciseServiceProtocol {
        return exerciseservice as ExerciseServiceProtocol
    }
    
    var approaches: ApproachServiceProtocol {
        return approachService as ApproachServiceProtocol
    }
    
    var user: UserServiceProtocol {
        return userService as UserServiceProtocol
    }
    
    var workoutTemplates: WorkoutTemplateServiceProtocol {
        return workoutTemplateService as WorkoutTemplateServiceProtocol
    }
}
