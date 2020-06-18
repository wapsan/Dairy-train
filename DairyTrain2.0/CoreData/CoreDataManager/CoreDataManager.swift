import Foundation
import CoreData

class CoreDataManager {
    
    //MARK: - Singletone propertie
    static let shared = CoreDataManager()
    
    //MARK: - Private properties
    private lazy var dataConteiner = AppDelegate.persistentContainer
    private lazy var managedContext = AppDelegate.persistentContainer.viewContext
    
    //MARK: - Private methods
    private func fetchMainInfoList() -> [MainInfoManagedObject]? {
        let fetchRequset: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject
            .fetchRequest()
        do {
            let mainInfoList = try self.managedContext.fetch(fetchRequset)
            return mainInfoList
        } catch {
            return nil
        }
    }
    
    private func updateContext() {
        if self.managedContext.hasChanges {
            do {
                try self.managedContext.save()
            } catch {
                print("Data don't update.")
            }
        }
    }
    
    //MARK: - Public methods
    func readUserMainInfo() -> MainInfoManagedObject? {
        let fetchRequset: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject
            .fetchRequest()
        do {
            let mainInfoList = try self.managedContext.fetch(fetchRequset)
            if mainInfoList.isEmpty {
                return nil
            } else {
                return mainInfoList[0]
            }
        } catch {
            return nil
        }
    }
    
    func updateAge(to age: Int) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.age = Int64(age)
        } else {
            mainInfoList[0].age = Int64(age)
        }
        self.updateContext()
    }
    
    func updateWeight(to weight: Float) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.weight = weight
        } else {
            mainInfoList[0].weight = weight
        }
        self.updateContext()
    }
    
    func updateHeight(to heigth: Float) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.height = heigth
        } else {
            mainInfoList[0].height = heigth
        }
        self.updateContext()
    }
    
    func updateGender(to gender: UserMainInfoModel.Gender) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.gender = gender.rawValue
        } else {
            mainInfoList[0].gender = gender.rawValue
        }
        self.updateContext()
    }
    
    func updateActivityLevel(to activitylevel: UserMainInfoModel.ActivityLevel) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.activitylevel = activitylevel.rawValue
        } else {
            mainInfoList[0].activitylevel = activitylevel.rawValue
        }
        self.updateContext()
    }
    
    func updateHeightMode(to heightMode: MeteringSetting.HeightMode) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.heightMode = heightMode.rawValue
        } else {
            mainInfoList[0].heightMode = heightMode.rawValue
        }
        self.updateContext()
    }
    
    func updateWeightMode(to weightMode: MeteringSetting.WeightMode) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.weightMode = weightMode.rawValue
        } else {
            mainInfoList[0].weightMode = weightMode.rawValue
        }
        self.updateContext()
    }
    
    func updateUserMainInfo(to userMainInfo: UserMainInfoModel) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.managedContext)
            newMainInfo.age = Int64(userMainInfo.age ?? 0)
            newMainInfo.height = userMainInfo.height ?? 0
            newMainInfo.weight = userMainInfo.weight ?? 0
            newMainInfo.height = userMainInfo.height ?? 0
            newMainInfo.gender = userMainInfo.gender?.rawValue
            newMainInfo.activitylevel = userMainInfo.activityLevel?.rawValue
            newMainInfo.heightMode = userMainInfo.heightMode?.rawValue
            newMainInfo.weightMode = userMainInfo.weightMode?.rawValue
        } else {
            mainInfoList[0].age = Int64(userMainInfo.age ?? 0)
            mainInfoList[0].height = userMainInfo.height ?? 0
            mainInfoList[0].weight = userMainInfo.weight ?? 0
            mainInfoList[0].height = userMainInfo.height ?? 0
            mainInfoList[0].gender = userMainInfo.gender?.rawValue
            mainInfoList[0].activitylevel = userMainInfo.activityLevel?.rawValue
            mainInfoList[0].heightMode = userMainInfo.heightMode?.rawValue
            mainInfoList[0].weightMode = userMainInfo.weightMode?.rawValue
        }
        self.updateContext()
    }
    
    func deleteUserMainInfoData(completion: @escaping () -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MainInfo")
        guard let result = try? self.managedContext.fetch(fetchRequest) else { return }
        for object in result {
            self.managedContext.delete(object)
            self.updateContext()
        }
        completion()
    }
    
    func isAnyDataSaved() -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MainInfo")
        guard let result = try? self.managedContext.fetch(fetchRequest) else { return false }
        if result.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    //MARK: - Initialization
    private init() { }
}
