import Foundation
import CoreData
  
final class UserDataManager {

    //MARK: - Singletone propertie
    static let shared = UserDataManager()
    
    //MARK: - Private properties
    private let dataModelName = "UserMainInfo"
    
    private lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistantContainer.viewContext
    }()
    
    //MARK: - Private methods
    private func updateContext() {
        guard context.hasChanges else { return }
        do {
            try self.context.save()
        } catch {
            print("MainInfoContext don't update")
        }
    }

    //MARK: - Public methods
    func readUserMainInfo() -> MainInfoManagedObject? {
        let fetchRequset: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject
            .fetchRequest()
        if let mainInfoList = try? self.context.fetch(fetchRequset) {
            return mainInfoList.isEmpty ? nil : mainInfoList.first
        } else {
            return nil
        }
    }
    
    func updateDateOfLastUpdateTo(_ date: String?) {
        if let userMainInfo = self.readUserMainInfo() {
            userMainInfo.dateOfLastUpdate = date
            self.updateContext()
        } else {
            let newUserMainInfo = MainInfoManagedObject(context: self.context)
            newUserMainInfo.dateOfLastUpdate = date
            self.updateContext()
        }
    }
    
    func updateAge(to age: Int) {
        if let userMainInfo = self.readUserMainInfo() {
            userMainInfo.age = Int64(age)
            self.updateContext()
        } else {
            let newUserMainInfo = MainInfoManagedObject(context: self.context)
            newUserMainInfo.age = Int64(age)
            self.updateContext()
        }
    }
    
    func updateWeight(to weight: Float) {
        if let userMainInfo = self.readUserMainInfo() {
            userMainInfo.weight = weight
            userMainInfo.weightMode = MeteringSetting.shared.weightMode.rawValue
            self.updateContext()
        } else {
            let newUserMainInfo = MainInfoManagedObject(context: self.context)
            newUserMainInfo.weight = weight
            newUserMainInfo.weightMode = MeteringSetting.shared.weightMode.rawValue
            self.updateContext()
        }
    }
    
    func updateHeight(to heigth: Float) {
        if let userMainInfo = self.readUserMainInfo() {
            userMainInfo.height = heigth
            userMainInfo.heightMode = MeteringSetting.shared.heightMode.rawValue
            self.updateContext()
        } else {
            let newUserMainInfo = MainInfoManagedObject(context: self.context)
            newUserMainInfo.height = heigth
            newUserMainInfo.heightMode = MeteringSetting.shared.heightMode.rawValue
            self.updateContext()
        }
    }
    
    func updateGender(to gender: UserMainInfoCodableModel.Gender) {
        if let userMainInfo = self.readUserMainInfo() {
            userMainInfo.gender = gender.rawValue
            self.updateContext()
        } else {
            let newUserMainInfo = MainInfoManagedObject(context: self.context)
            newUserMainInfo.gender = gender.rawValue
            self.updateContext()
        }
    }
    
    func updateActivityLevel(to activitylevel: UserMainInfoCodableModel.ActivityLevel) {
        if let userMainInfo = self.readUserMainInfo() {
            userMainInfo.activitylevel = activitylevel.rawValue
            self.updateContext()
        } else {
            let newUserMainInfo = MainInfoManagedObject(context: self.context)
            newUserMainInfo.activitylevel = activitylevel.rawValue
            self.updateContext()
        }
    }
    
    func updateUserHeightMode(to userHeightMode: MeteringSetting.HeightMode) {
        if let mainUserInfo = self.readUserMainInfo() {
            mainUserInfo.heightMode = userHeightMode.rawValue
        } else {
            let newMainInfo = MainInfoManagedObject(context: self.context)
            newMainInfo.heightMode = userHeightMode.rawValue
        }
    }
    
    func updateUserWeightMode(to userWeightMode: MeteringSetting.WeightMode) {
        if let mainUserInfo = self.readUserMainInfo()  {
            mainUserInfo.weightMode = userWeightMode.rawValue
        } else {
            let newMainInfo = MainInfoManagedObject(context: self.context)
            newMainInfo.weightMode = userWeightMode.rawValue
        }
    }
    
    func isSettingSaved() -> Bool {
         if let mainUserInfo = self.readUserMainInfo() {
            if let _ = mainUserInfo.weightMode,
               let _ = mainUserInfo.heightMode {
                return true
            } else {
              return false
            }
        } else {
            return false
        }
    }
    
    func getNutritionMode() -> NutritionMode {
        guard let user = readUserMainInfo() else {
            return .balanceWeight
        }
        guard let nutritionMode = NutritionMode(rawValue: user.nutritionMode) else {
            return .balanceWeight
        }
        return nutritionMode
    }
    
    func updateNutritionMode(to nutritionMode: NutritionMode) {
        guard let user = readUserMainInfo() else { return }
        user.nutritionMode = nutritionMode.rawValue
        updateContext()
    }
    
    func updateUserMainInfo(to userMainInfo: UserMainInfoCodableModel) {
        if let mainUserInfo = self.readUserMainInfo() {
            mainUserInfo.age = Int64(userMainInfo.age ?? 0)
            mainUserInfo.height = userMainInfo.height ?? 0
            mainUserInfo.weight = userMainInfo.weight ?? 0
            mainUserInfo.height = userMainInfo.height ?? 0
            mainUserInfo.gender = userMainInfo.gender?.rawValue
            mainUserInfo.activitylevel = userMainInfo.activityLevel?.rawValue
            mainUserInfo.heightMode = userMainInfo.heightMode?.rawValue
            mainUserInfo.weightMode = userMainInfo.weightMode?.rawValue
            mainUserInfo.nutritionMode = userMainInfo.nutritionMode ?? "Balance Weight"
        } else {
            let newMainInfo = MainInfoManagedObject(context: self.context)
            newMainInfo.age = Int64(userMainInfo.age ?? 0)
            newMainInfo.height = userMainInfo.height ?? 0
            newMainInfo.weight = userMainInfo.weight ?? 0
            newMainInfo.height = userMainInfo.height ?? 0
            newMainInfo.gender = userMainInfo.gender?.rawValue
            newMainInfo.activitylevel = userMainInfo.activityLevel?.rawValue
            newMainInfo.heightMode = userMainInfo.heightMode?.rawValue
            newMainInfo.weightMode = userMainInfo.weightMode?.rawValue
            newMainInfo.nutritionMode = userMainInfo.nutritionMode ?? "Balance Weight"
        }
        self.updateContext()
    }
    
    func deleteUserMainInfoData(completion: @escaping () -> Void) {
        let fetchRequest: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject.fetchRequest()
        guard let result = try? self.context.fetch(fetchRequest) else { return }
        for object in result {
            self.context.delete(object)
            self.updateContext()
        }
        completion()
    }
        
    func removeAllUserData(_ completionHandler: @escaping () -> Void) {
        let fetchMainInfoRequest: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject.fetchRequest()
        if let mainInfoList = try? self.context.fetch(fetchMainInfoRequest) {
            for object in mainInfoList {
                self.context.delete(object)
            }
        }
        TrainingDataManager.shared.removeAllData()
        self.updateContext()
        completionHandler()
    }
    
    //MARK: - Initialization
    private init() { }
}
