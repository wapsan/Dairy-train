import Foundation
import CoreData

struct CoreDataModelName {
    static let userMainInfo = "UserMainInfo"
    static let userTrainInfo = "UserTrainingInfo"
}

class CoreDataManager {
    
    //MARK: - Enums
    enum EntitiesName: String {
        case mainInfo = "MainInfo"
        case training = "Training"
        case exercise = "Exercise"
        case aproach = "Aproach"
    }
    
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
    private func fetchMainInfoList() -> [MainInfoManagedObject]? {
        let fetchRequset: NSFetchRequest<MainInfoManagedObject> = MainInfoManagedObject
            .fetchRequest()
        do {
            let mainInfoList = try self.mainInfoContext.fetch(fetchRequset)
            return mainInfoList
        } catch {
            return nil
        }
    }
    
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
        do {
            let mainInfoList = try self.mainInfoContext.fetch(fetchRequset)
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
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.age = Int64(age)
        } else {
            mainInfoList[0].age = Int64(age)
        }
        self.updateMainInfoContext()
    }
    
    func updateWeight(to weight: Float) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.weight = weight
        } else {
            mainInfoList[0].weight = weight
        }
        self.updateMainInfoContext()
    }
    
    func updateHeight(to heigth: Float) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.height = heigth
        } else {
            mainInfoList[0].height = heigth
        }
       self.updateMainInfoContext()
    }
    
    func updateGender(to gender: UserMainInfoModel.Gender) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.gender = gender.rawValue
        } else {
            mainInfoList[0].gender = gender.rawValue
        }
        self.updateMainInfoContext()
    }
    
    func updateActivityLevel(to activitylevel: UserMainInfoModel.ActivityLevel) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.activitylevel = activitylevel.rawValue
        } else {
            mainInfoList[0].activitylevel = activitylevel.rawValue
        }
        self.updateMainInfoContext()
    }
    
    func updateHeightMode(to heightMode: MeteringSetting.HeightMode) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.heightMode = heightMode.rawValue
        } else {
            mainInfoList[0].heightMode = heightMode.rawValue
        }
       self.updateMainInfoContext()
    }
    
    func updateWeightMode(to weightMode: MeteringSetting.WeightMode) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
            newMainInfo.weightMode = weightMode.rawValue
        } else {
            mainInfoList[0].weightMode = weightMode.rawValue
        }
        self.updateMainInfoContext()
    }
    
    func updateUserMainInfo(to userMainInfo: UserMainInfoModel) {
        guard let mainInfoList = self.fetchMainInfoList() else { return }
        if mainInfoList.isEmpty {
            let newMainInfo = MainInfoManagedObject(context: self.mainInfoContext)
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
        self.updateMainInfoContext()
    }
    
    func deleteUserMainInfoData(completion: @escaping () -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntitiesName.mainInfo.rawValue)
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

    func removeTraining(_ trainingListForRemoving: [TrainingManagedObject]) {
        for train in trainingListForRemoving {
            self.trainInfoContext.delete(train)
        }
        self.updateTrainInfoContext()
    }
    
    func fetchExercisesFor(_ choosenTrain: TrainingManagedObject) -> [ExerciseManagedObject] {
//        let fetchRequest: NSFetchRequest<TrainingManagedObject> = TrainingManagedObject.fetchRequest()
//        var exerciceListTrain: [ExerciseManagedObject] = []
//        if let dataBaseTrainList = try? self.trainInfoContext.fetch(fetchRequest) {
//            dataBaseTrainList.forEach({
//                if $0.objectID == choosenTrain.objectID {
//                    exerciceListTrain = $0.exercicesArray
//                }
//            })
//        }
       // return exerciceListTrain
        return choosenTrain.exercicesArray
    }
    
    func addExercisesToTtrain(_ exercises: [Exercise]) -> Bool {
        let trainingList = self.fetchTrainingList()
        var exerciseNameSet = Set<String>()
        var newExercises: [ExerciseManagedObject] = []
        if trainingList.isEmpty {
            for exercise in exercises {
                let newExercice = ExerciseManagedObject(context: self.trainInfoContext)
                newExercice.id = Int64(newExercises.count + 1)
                newExercice.name = exercise.name
                newExercice.groupName = exercise.group.rawValue
                newExercice.subgroupName = exercise.subgroub.rawValue
                newExercises.append(newExercice)
            }
            let newTrain = TrainingManagedObject(context: self.trainInfoContext)
            newTrain.date = Date()
            newTrain.formatedDate = DateHelper.shared.currnetDate
            newTrain.exercises = NSSet(array: newExercises)
            self.updateTrainInfoContext()
            return true
        } else {
            let fethcRequest: NSFetchRequest<TrainingManagedObject> = TrainingManagedObject.fetchRequest()
            let curentDate = DateHelper.shared.currnetDate
            fethcRequest.predicate = NSPredicate(format: "formatedDate == %@", curentDate as CVarArg )
            if let trainingListf = try? self.trainInfoContext.fetch(fethcRequest),
                let todaysTraon = trainingListf.first {
                newExercises = []
                for exerciseFromBase in todaysTraon.exercicesArray {
                    exerciseNameSet.insert(exerciseFromBase.name)
                }
                for newExercise in exercises {
                    if exerciseNameSet.insert(newExercise.name).inserted {
                        let newEx = ExerciseManagedObject(context: self.trainInfoContext)
                        newEx.id = Int64(todaysTraon.exercicesArray.count + 1)
                        newEx.name = newExercise.name
                        newEx.groupName = newExercise.group.rawValue
                        newEx.subgroupName = newExercise.subgroub.rawValue
                        newExercises.append(newEx)
                    }
                }
                todaysTraon.addToExercises(NSSet(array: newExercises))
            } else {
                newExercises = []
                for newExercise in exercises {
                    if exerciseNameSet.insert(newExercise.name).inserted {
                        let newEx = ExerciseManagedObject(context: self.trainInfoContext)
                        newEx.id = Int64(newExercises.count + 1)
                        newEx.name = newExercise.name
                        newEx.groupName = newExercise.group.rawValue
                        newEx.subgroupName = newExercise.subgroub.rawValue
                        newExercises.append(newEx)
                    }
                }
                let newTrain = TrainingManagedObject(context: self.trainInfoContext)
                newTrain.date = Date()
                newTrain.formatedDate = DateHelper.shared.currnetDate
                newTrain.exercises = NSSet(array: newExercises)
            }
            self.updateTrainInfoContext()
            return false
        }
    }
    
    func removeExercise(_ exercise: ExerciseManagedObject, from train: TrainingManagedObject) {
//        let fethcRequest: NSFetchRequest<TrainingManagedObject> = TrainingManagedObject.fetchRequest()
//        guard let trainDate = train.formatedDate else { return }
//        fethcRequest.predicate = NSPredicate(format: "formatedDate == %@", trainDate)
//        if let trainingList = try? self.trainInfoContext.fetch(fethcRequest),
//            let currentTrain = trainingList.first {
//            currentTrain.exercicesArray.forEach({
//                if $0.id == exercise.id {
//                    currentTrain.removeFromExercises($0)
//                }
//            })
//            self.updateTrainInfoContext()
//        }
        train.removeFromExercises(exercise)
        self.updateTrainInfoContext()
    }
    
    func addAproachWith(_ weight: Float, and reps: Int, to exercise: ExerciseManagedObject) {
        let newAproach = AproachManagedObject(context: self.trainInfoContext)
        newAproach.number = Int64(exercise.aproachesArray.count + 1)
        newAproach.weight = weight
        newAproach.reps = Int64(reps)
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
