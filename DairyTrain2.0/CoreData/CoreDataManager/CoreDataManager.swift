import Foundation
import CoreData

struct CoreDataModelName {
    static let userMainInfo = "UserMainInfo"
    static let userTrainInfo = "UserTrainingInfo"
}

class CoreDataManager {
    
    //MARK: - Enums
//    enum EntitiesName: String {
//        case mainInfo = "MainInfo"
//        case training = "Training"
//        case exercise = "Exercise"
//        case aproach = "Aproach"
//    }
    
    //MARK: - Singletone propertie
    static let shared = CoreDataManager()
    
    //MARK: - Private properties
    private lazy var mainInfoContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataModelName.userMainInfo)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainInfoContext: NSManagedObjectContext {
        return self.mainInfoContainer.viewContext
    }
    
    private lazy var trainInfoContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataModelName.userTrainInfo)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var trainInfoContext: NSManagedObjectContext {
        return self.trainInfoContainer.viewContext
    }
    
    //MARK: - Private methods
    private func updateMainInfoContext() {
        if self.mainInfoContext.hasChanges {
            do {
                try self.mainInfoContext.save()
            } catch {
                print("Data don't update.")
            }
        }
    }
    
    private func updateTrainInfoContext() {
        if self.trainInfoContext.hasChanges {
            do {
                try self.trainInfoContext.save()
            } catch {
                print("Data don't update.")
            }
        }
    }
    
    //MARK: - Public methods
    func readUserMainInfo() -> MainInfoManagedObject? {
        let fetchRequset: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject
            .fetchRequest()
        if let mainInfoList = try? self.mainInfoContext.fetch(fetchRequset) {
            return mainInfoList.isEmpty ? nil : mainInfoList.first
        } else {
            return nil
        }
    }
    
    func updateAge(to age: Int) {
        guard let userMainInfo = self.readUserMainInfo() else { return }
        userMainInfo.age = Int64(age)
        self.updateMainInfoContext()
    }
    
    func updateWeight(to weight: Float) {
        guard let mainInfo = self.readUserMainInfo() else { return }
        mainInfo.weight = weight
        mainInfo.weightMode = MeteringSetting.shared.weightMode.rawValue
        self.updateMainInfoContext()
    }
    
    func updateHeight(to heigth: Float) {
        guard let mainInfo = self.readUserMainInfo() else { return }
        mainInfo.height = heigth
        mainInfo.heightMode = MeteringSetting.shared.heightMode.rawValue
        self.updateMainInfoContext()
    }
    
    func updateGender(to gender: UserMainInfoModel.Gender) {
        guard let mainInfo = self.readUserMainInfo() else { return }
        mainInfo.gender = gender.rawValue
        self.updateMainInfoContext()
    }
    
    func updateActivityLevel(to activitylevel: UserMainInfoModel.ActivityLevel) {
        guard let mainInfo = self.readUserMainInfo() else { return }
        mainInfo.activitylevel = activitylevel.rawValue
        self.updateMainInfoContext()
    }
    
    func updateHeightMode(to heightMode: MeteringSetting.HeightMode) {
        guard let mainUserInfo = self.readUserMainInfo() else { return }
        mainUserInfo.heightMode = heightMode.rawValue
        mainUserInfo.height = mainUserInfo.height * MeteringSetting.shared.heightMultiplier
        self.updateMainInfoContext()
    }
    
    func updateWeightMode(to weightMode: MeteringSetting.WeightMode) {
        guard let mainUserInfo = self.readUserMainInfo() else { return }
        mainUserInfo.weightMode = weightMode.rawValue
        mainUserInfo.weight = mainUserInfo.weight / MeteringSetting.shared.weightMultiplier
        self.updateMainInfoContext()
    }
    
    func updateUserMainInfo(to userMainInfo: UserMainInfoModel) {
        if let mainUserInfo = self.readUserMainInfo() {
            mainUserInfo.age = Int64(userMainInfo.age ?? 0)
            mainUserInfo.height = userMainInfo.height ?? 0
            mainUserInfo.weight = userMainInfo.weight ?? 0
            mainUserInfo.height = userMainInfo.height ?? 0
            mainUserInfo.gender = userMainInfo.gender?.rawValue
            mainUserInfo.activitylevel = userMainInfo.activityLevel?.rawValue
            mainUserInfo.heightMode = userMainInfo.heightMode?.rawValue
            mainUserInfo.weightMode = userMainInfo.weightMode?.rawValue
        } else {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.age = Int64(userMainInfo.age ?? 0)
            newMainInfo.height = userMainInfo.height ?? 0
            newMainInfo.weight = userMainInfo.weight ?? 0
            newMainInfo.height = userMainInfo.height ?? 0
            newMainInfo.gender = userMainInfo.gender?.rawValue
            newMainInfo.activitylevel = userMainInfo.activityLevel?.rawValue
            newMainInfo.heightMode = userMainInfo.heightMode?.rawValue
            newMainInfo.weightMode = userMainInfo.weightMode?.rawValue
        }
        self.updateMainInfoContext()
    }
    
    func deleteUserMainInfoData(completion: @escaping () -> Void) {
       // let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntitiesName.mainInfo.rawValue)
        let fetchRequest: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject.fetchRequest()
        guard let result = try? self.mainInfoContext.fetch(fetchRequest) else { return }
        for object in result {
            self.mainInfoContext.delete(object)
            self.updateMainInfoContext()
        }
        completion()
    }
    
    //MARK: - Train info block
    func fetchTrainingList() -> [TrainingManagedObject] {
        let fetchRequest: NSFetchRequest<TrainingManagedObject> = TrainingManagedObject.fetchRequest()
        if let trainingList = try? self.trainInfoContext.fetch(fetchRequest) {
            return trainingList.sorted(by: { $0.date > $1.date })
        } else {
            return []
        }
    }
    
    func removeAllTraining(_ trainingListForRemoving: [TrainingManagedObject]) {
        for train in trainingListForRemoving {
            self.trainInfoContext.delete(train)
        }
        self.updateTrainInfoContext()
    }
    
    func fetchExercisesFor(_ choosenTrain: TrainingManagedObject) -> [ExerciseManagedObject] {
        return choosenTrain.exercicesArray
    }
    
    func addExercisesToTrain(_ exercises: [Exercise]) -> Bool {
        let trainingList = self.fetchTrainingList()
        var exerciseNameSet = Set<String>()
        var newExercises: [ExerciseManagedObject] = []
        if trainingList.isEmpty {
            print("Create new train block in empty trainlist")
            let newTrain = TrainingManagedObject(context: self.trainInfoContext)
            for exercise in exercises {
                let newExercice = ExerciseManagedObject(context: self.trainInfoContext)
                newExercice.id = Int64(newExercises.count + 1)
                newExercice.name = exercise.name
                newExercice.groupName = exercise.group.rawValue
                newExercice.subgroupName = exercise.subgroub.rawValue
                newExercice.training = newTrain
                newExercises.append(newExercice)
            }
            newTrain.date = Date()
            newTrain.formatedDate = DateHelper.shared.currnetDate
            newTrain.exercises = NSSet(array: newExercises)
            self.updateTrainInfoContext()
            return true
        } else {
            print("Add exercices to today train")
            newExercises = []
            for train in trainingList {
                if train.formatedDate! == DateHelper.shared.currnetDate {
                    if let todayTrain = trainingList.first {
                        todayTrain.exercicesArray.forEach({ (exercise) in
                            exerciseNameSet.insert(exercise.name)
                        })
                        for newExercise in exercises {
                            if exerciseNameSet.insert(newExercise.name).inserted {
                                let newEx = ExerciseManagedObject(context: self.trainInfoContext)
                                newEx.id = Int64(todayTrain.exercicesArray.count + 1)
                                newEx.name = newExercise.name
                                newEx.groupName = newExercise.group.rawValue
                                newEx.subgroupName = newExercise.subgroub.rawValue
                                newEx.training = todayTrain
                                newExercises.append(newEx)
                            }
                        }
                        todayTrain.addToExercises(NSSet(array: newExercises))
                        self.updateTrainInfoContext()
                        return false
                    }
                }
            }
            print("Add new train with not empty training list")
            newExercises = []
            let newTrain = TrainingManagedObject(context: self.trainInfoContext)
            for newExercise in exercises {
                if exerciseNameSet.insert(newExercise.name).inserted {
                    let newEx = ExerciseManagedObject(context: self.trainInfoContext)
                    newEx.id = Int64(newExercises.count + 1)
                    newEx.name = newExercise.name
                    newEx.groupName = newExercise.group.rawValue
                    newEx.subgroupName = newExercise.subgroub.rawValue
                    newEx.training = newTrain
                    newExercises.append(newEx)
                }
            }
            newTrain.date = Date()
            newTrain.formatedDate = DateHelper.shared.currnetDate
            newTrain.exercises = NSSet(array: newExercises)
            self.updateTrainInfoContext()
            return false
        }
    }
    
    
    func removeExercise(_ exercise: ExerciseManagedObject, from train: TrainingManagedObject) {
        train.removeFromExercises(exercise)
        self.updateTrainInfoContext()
    }
    
    func addAproachWith(_ weight: Float, and reps: Int, to exercise: ExerciseManagedObject) {
        let newAproach = AproachManagedObject(context: self.trainInfoContext)
        newAproach.number = Int64(exercise.aproachesArray.count + 1)
        newAproach.weight = weight
        newAproach.reps = Int64(reps)
        newAproach.weightMode = MeteringSetting.shared.weightMode.rawValue
        newAproach.exercise = exercise
        self.updateTrainInfoContext()
    }
    
    func changeAproachAt(_ index: Int,
                         in exercise: ExerciseManagedObject,
                         to weight: Float,
                         and reps: Int) {
        let changedAproach = exercise.aproachesArray[index]
        changedAproach.weight = weight
        changedAproach.reps = Int64(reps)
        self.updateTrainInfoContext()
    }
    
    func removeAproachIn(_ exercise: ExerciseManagedObject) {
        if !exercise.aproachesArray.isEmpty {
            exercise.aproachesArray.removeLast()
        }
        self.updateTrainInfoContext()
    }
    
    func removeAllUserData() {
        let fetchMainInfoRequest: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject.fetchRequest()
        let fetchTrainInfoRequest: NSFetchRequest<TrainingManagedObject> = TrainingManagedObject.fetchRequest()
        if let mainInfoList = try? self.mainInfoContext.fetch(fetchMainInfoRequest) {
            for object in mainInfoList {
                self.mainInfoContext.delete(object)
            }
        }
        if let trainingInfo = try? self.trainInfoContext.fetch(fetchTrainInfoRequest) {
            for object in trainingInfo {
                self.trainInfoContext.delete(object)
            }
        }
    }
    
    //MARK: - Initialization
    private init() { }
}
