import Foundation
import CoreData
import RxSwift

final class TrainingDataManager {
    
    //MARK: - Singletone init
    static let shared = TrainingDataManager()
    private init() {}
    
    //MARK: - Private properties
    private let dataModelName = "UserTrainingInfo"
    
    private lazy var trainInfoContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var trainInfoContext: NSManagedObjectContext = {
        return self.trainInfoContainer.viewContext
    }()

    //MARK: - Private methods
    private func updateContext() {
        guard trainInfoContext.hasChanges else { return }
        do {
            try trainInfoContext.save()
        } catch {
            print("TrainInfoContext dont't update")
        }
    }
    
    //MARK: - Training private methods
    private func createTraing(with exercises: [Exercise]) {
        let newTraining = TrainingManagedObject(context: trainInfoContext)
        var newExercises: [ExerciseManagedObject] = []
        exercises.forEach({ exercise in
            let newExercice = ExerciseManagedObject(context: self.trainInfoContext)
            newExercice.id = Int64(newExercises.count + 1)
            newExercice.name = exercise.name
            newExercice.groupName = exercise.group.rawValue
            newExercice.subgroupName = exercise.subgroub.rawValue
            newExercice.training = newTraining
            newExercice.date = Date()
            newExercises.append(newExercice)
        })
        newTraining.date = Date()
        newTraining.formatedDate = DateHelper.shared.currnetDate
        newTraining.exercises = NSSet(array: newExercises)
    }
    
    private func addExerciseToExitingTraining(with exitingTraining: inout TrainingManagedObject,
                                              and newExercises: [Exercise]) {
        var exetingExerciseNameSet = Set<String>()
        var newManagedExercises: [ExerciseManagedObject] = []
        exitingTraining.exercicesArray.forEach({ exitingExercise in
            exetingExerciseNameSet.insert(exitingExercise.name)
        })
        newExercises.forEach({ newExercise in
            guard exetingExerciseNameSet.insert(newExercise.name).inserted else { return }
                let newManagedEexercise = ExerciseManagedObject(context: self.trainInfoContext)
                newManagedEexercise.id = Int64(exitingTraining.exercicesArray.count + 1)
                newManagedEexercise.name = newExercise.name
                newManagedEexercise.groupName = newExercise.group.rawValue
                newManagedEexercise.subgroupName = newExercise.subgroub.rawValue
                newManagedEexercise.training = exitingTraining
                newManagedEexercise.date = Date()
                newManagedExercises.append(newManagedEexercise)
            
        })
        guard !newManagedExercises.isEmpty else { return }
        exitingTraining.addToExercises(NSSet(array: newManagedExercises))
    }
    
    
    //MARK: - Training publick methods
    func getTraingList() -> [TrainingManagedObject] {
        let fetchRequest: NSFetchRequest<TrainingManagedObject> = TrainingManagedObject.fetchRequest()
        guard let trainingList = try? self.trainInfoContext.fetch(fetchRequest) else { return [] }
        return trainingList.sorted(by: { $0.date > $1.date })
    }
    
    func addExercisesToTrain(_ exercises: [Exercise]) -> Bool {
        let trainingList = getTraingList()
        guard !trainingList.isEmpty else {
            createTraing(with: exercises)
            updateContext()
            return true
        }
        if var todaysTraining = trainingList.first(where: {$0.formatedDate == DateHelper.shared.currnetDate}) {
            addExerciseToExitingTraining(with: &todaysTraining, and: exercises)
            updateContext()
            return false
        } else {
            createTraing(with: exercises)
            updateContext()
            return true
        }
    }
    
    func removeChoosenTrainings(_ trainingListForRemoving: [TrainingManagedObject]) {
        for train in trainingListForRemoving {
            self.trainInfoContext.delete(train)
        }
        self.updateContext()
    }
    
    //MARK: - Exercises public methods
    func getExercices(for choosenTraining: TrainingManagedObject) -> [ExerciseManagedObject] {
        return choosenTraining.exercicesArray
    }
    
    func getAllExerciseForStatistics(with name: String) -> [ExerciseManagedObject] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let predicate = NSPredicate(format: "name == %@", name)
        let descriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [descriptor]
        guard let exercisesWithName = try? trainInfoContext.fetch(fetchRequest) as? [ExerciseManagedObject] else {
            return []
        }
        return exercisesWithName
    }
    
    func removeExercise(_ exercise: ExerciseManagedObject, from train: TrainingManagedObject) {
        train.removeFromExercises(exercise)
        if train.exercicesArray.isEmpty {
            self.removeChoosenTrainings([train])
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        }
        self.updateContext()
    }
    
    
    //MARK: - Aproach publick methods
    func addAproachWith(_ weight: Float, and reps: Int, to exercise: ExerciseManagedObject) {
        let newAproach = AproachManagedObject(context: self.trainInfoContext)
        newAproach.number = Int64(exercise.aproachesArray.count + 1)
        newAproach.weight = weight
        newAproach.reps = Int64(reps)
        newAproach.weightMode = MeteringSetting.shared.weightMode.rawValue
        newAproach.exercise = exercise
        self.updateContext()
    }
    
    func changeAproachAt(_ index: Int,
                         in exercise: ExerciseManagedObject,
                         with weight: Float,
                         and reps: Int) {
        let changedAproach = exercise.aproachesArray[index]
        changedAproach.weight = weight
        changedAproach.reps = Int64(reps)
        self.updateContext()
    }
    
    func removeAproachIn(_ exercise: ExerciseManagedObject) {
        if !exercise.aproachesArray.isEmpty {
            exercise.aproachesArray.removeLast()
        }
        self.updateContext()
    }
    
    //MARK: - Training paterns publick methods
    var trainingPatern: BehaviorSubject<[TrainingPaternManagedObject]> = BehaviorSubject(value: [])
    var curentPatern: BehaviorSubject<TrainingPaternManagedObject?> = BehaviorSubject(value: nil)
    
    func updateTrainingPaterns() {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        if let trainingPaterns = try? self.trainInfoContext.fetch(fetchRequest) {
            trainingPatern.onNext(trainingPaterns.sorted(by: {$0.date < $1.date}))
        } else {
            trainingPatern.onNext([])
        }
    }
    
    func fetchTrainingPaterns() -> [TrainingPaternManagedObject] {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        if let trainingPaterns = try? self.trainInfoContext.fetch(fetchRequest) {
            return trainingPaterns.sorted(by: {$0.date < $1.date})
        } else {
            return []
        }
    }
    
    func creteTrainingPatern(with name: String) {
        let newTrainingPatern = TrainingPaternManagedObject(context: trainInfoContext)
        newTrainingPatern.name = name
        newTrainingPatern.date = Date()
        self.updateContext()
        self.updateTrainingPaterns()
    }
 
    func loadPatern(with date: Date) {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        if let patern = try? trainInfoContext.fetch(fetchRequest).first {
            self.curentPatern.onNext(patern)
        }
    }
    
    func addExercicese(_ exercises: [Exercise], to trainingPatern: TrainingPaternManagedObject) {
        var exerciseList: [ExerciseManagedObject] = []
        exercises.forEach({
            let newExercise = ExerciseManagedObject(context: trainInfoContext)
            newExercise.name = $0.name
            newExercise.groupName = $0.group.rawValue
            newExercise.subgroupName = $0.subgroub.rawValue
            newExercise.date = Date()
            exerciseList.append(newExercise)
        })
        exerciseList.forEach({ trainingPatern.addToExercises($0) })
        curentPatern.onNext(trainingPatern)
        updateContext()
    }
    
    func renameTrainingPatern(with date: Date, with name: String) {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        if let patern = try? trainInfoContext.fetch(fetchRequest).first {
            patern.name = name
            updateContext()
            trainingPatern.onNext([])
            self.updateTrainingPaterns()
        }
    }

    func renameTrainingPatern(at index: Int, with name: String) {
        fetchTrainingPaterns()[index].name = name
        updateContext()
        trainingPatern.onNext([])
        self.updateTrainingPaterns()
    }

    func removeTrainingPatern(at index: Int) {
        self.trainInfoContext.delete(fetchTrainingPaterns()[index])
        self.updateContext()
        self.updateTrainingPaterns()
    }
    
    //MARK: - Backup methods
    func updateUserTrainInfoFrom(_ trainingArray: [TrainingCodableModel]) {
        for training in trainingArray {
            let newTrain = TrainingManagedObject(context: self.trainInfoContext)
            newTrain.formatedDate = training.formatedDate
            newTrain.date = training.date
            for exercice in training.exerciceArray {
                let newExercice = ExerciseManagedObject(context: self.trainInfoContext)
                newExercice.name = exercice.name
                newExercice.subgroupName = exercice.subgroupName
                newExercice.groupName = exercice.groupName
                newExercice.id = Int64(exercice.id)
                newExercice.training = newTrain
                newExercice.date = training.date
                newTrain.addToExercises(newExercice)
                for aproach in exercice.aproachlist {
                    let newAproah = AproachManagedObject(context: self.trainInfoContext)
                    newAproah.number = Int64(aproach.number)
                    newAproah.reps = Int64(aproach.reps)
                    newAproah.weight = aproach.weight
                    newAproah.weightMode = aproach.weightMode
                    newAproah.exercise = newExercice
                    newExercice.addToAproaches(newAproah)
                }
            }
        }
        NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        self.updateContext()
    }
    
    func removeAllData() {
        getTraingList().forEach({ trainInfoContext.delete($0)})
    }
}
