import Foundation
import CoreData

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
        var displayID: Int64 = 0
        exercises.forEach({ exercise in
            let newExercice = ExerciseManagedObject(context: self.trainInfoContext)
            newExercice.id = displayID
            newExercice.name = exercise.name
            newExercice.groupName = exercise.group.rawValue
            newExercice.subgroupName = exercise.subgroub.rawValue
            newExercice.training = newTraining
            newExercice.date = Date()
            newExercises.append(newExercice)
            displayID += 1
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
                newManagedEexercise.id = Int64(exitingTraining.exercicesArray.count)
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
        return choosenTraining.exercicesArray.sorted(by: { $0.id < $1.id })
    }
    
    func getAllExerciseForStatistics(with name: String) -> [ExerciseManagedObject] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        let namePredicate = NSPredicate(format: "name == %@", name)
        let trainingExitingPredicate = NSPredicate(format: "training != nil")
        let finish = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, trainingExitingPredicate])
        let descriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = finish
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
    
    func markExercise(_ exercise: ExerciseManagedObject, as isDone: Bool) {
        exercise.isDone = isDone
        updateContext()
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
    var trainingPaterns: [TrainingPaternManagedObject] {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let trainingPaterns = try self.trainInfoContext.fetch(fetchRequest)
            return trainingPaterns
        } catch {
            return []
        }
    }
    
    func getPattern(for date: Date) -> TrainingPaternManagedObject? {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        do {
            let patern = try trainInfoContext.fetch(fetchRequest).first
            return patern
        } catch {
            return nil
        }
    }
    
    func addTrainingPatern(with name: String) {
        let newTrainingPatern = TrainingPaternManagedObject(context: trainInfoContext)
        newTrainingPatern.name = name
        newTrainingPatern.date = Date()
        updateContext()
    }
    
    func createTrainingPatern(wtih name: String, and exercise: [Exercise]) {
        let newTrainingPatern = TrainingPaternManagedObject(context: trainInfoContext)
        newTrainingPatern.name = name
        newTrainingPatern.date = Date()
        addExercicese(exercise, to: newTrainingPatern)
        updateContext()
    }
    
    func removeTrainingPatern(at index: Int) {
        trainInfoContext.delete(trainingPaterns[index])
        updateContext()
    }
    
    private func convertExercisesToMO(exercises: [Exercise]) -> [ExerciseManagedObject] {
        var exerciseList: [ExerciseManagedObject] = []
        var exerciseID: Int64 = 0
        exercises.forEach({
            let newExercise = ExerciseManagedObject(context: trainInfoContext)
            newExercise.id = exerciseID
            newExercise.name = $0.name
            newExercise.groupName = $0.group.rawValue
            newExercise.subgroupName = $0.subgroub.rawValue
            newExercise.date = Date()
            exerciseList.append(newExercise)
            exerciseID += 1
        })
        return exerciseList
    }

    func addExercicese(_ exercises: [Exercise], to trainingPatern: TrainingPaternManagedObject) {
        let exerciseList: [ExerciseManagedObject] = convertExercisesToMO(exercises: exercises)
        exerciseList.forEach({ trainingPatern.addToExercises($0) })
        updateContext()
    }
    
    func renameTrainingPatern(with date: Date, with name: String) {
        let fetchRequest: NSFetchRequest<TrainingPaternManagedObject> = TrainingPaternManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        if let patern = try? trainInfoContext.fetch(fetchRequest).first {
            patern.name = name
            updateContext()
        }
    }

    func updateTrainingPaternList(to paternList: [TrainingPaternCodableModel]) {
        paternList.forEach({ patern in
            let newPatern = TrainingPaternManagedObject(context: self.trainInfoContext)
            newPatern.name = patern.name
            newPatern.date = patern.date
            patern.exerciseArray.forEach({ exercise in
                let newExercise = ExerciseManagedObject(context: self.trainInfoContext)
                newExercise.name = exercise.name
                newExercise.subgroupName = exercise.subgroupName
                newExercise.groupName = exercise.groupName
                newExercise.id = Int64(exercise.id)
                newExercise.trainingPatern = newPatern
                newExercise.date = newPatern.date
                newPatern.addToExercises(newExercise)
            })
        })
        updateContext()
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
                newExercice.isDone = exercice.isDone ?? false
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
        trainingPaterns.forEach({ trainInfoContext.delete($0) })
        getTraingList().forEach({ trainInfoContext.delete($0)})
        updateContext()
    }
}
