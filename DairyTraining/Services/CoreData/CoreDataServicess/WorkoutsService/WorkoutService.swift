import CoreData
import Foundation

protocol WorkoutService2Protocol {
    var isTodayWorkoutExist: Bool { get }
    
    func deleteWorkout(workout: WorkoutMO)
    func fetchWorkouts(for timePeriod: WorkoutService.TimePeriod) -> [WorkoutMO]
    func fetchExercise(for workout: WorkoutMO) -> [ExerciseMO]
    func createWorkout(with exercises: [Exercise])
    func addExerciseToTodaysWorkout(exercise: [Exercise])
    func syncWorkoutsFromFirebase(workouts: [TrainingCodableModel])
    
    func setStart(for workout: WorkoutMO)
    func setFinish(for workout: WorkoutMO)
    
    func cleanAllWorkoutsData()
}

final class WorkoutService {
    
    //MARK: - Types
    enum TimePeriod: Int {
        case today
        case week
        case mounth
        case allTime
        
        var predicate: NSPredicate? {
            switch self {
            
            case .today:
                let currentDay = DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat)
                return NSPredicate(format: "formatedDate == %@", currentDay)
            case .week:
                return NSPredicate(format: "date =< %@", Date.weekPeriod() as CVarArg)
            case .mounth:
                return NSPredicate(format: "date =< %@", Date.mounthPeriod() as CVarArg)
            case .allTime:
                return nil
            }
        }
    }
    
    //MARK: - Properies
    private let storeType: PersistentStoreType
    
    private var context: NSManagedObjectContext {
        DataBase.shared.workoutContext(type: storeType)
    }
    
    //MARK: - Initialization
    init(storeType: PersistentStoreType = .prod) {
        self.storeType = storeType
    }
    
    //MARK: - Private methods
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Cannot save context")
        }
    }
}

//MARK: - WorkoutService2Protocol
extension WorkoutService: WorkoutService2Protocol {
    
    func cleanAllWorkoutsData() {
        let workoutsFetchRequest: NSFetchRequest<WorkoutMO> = WorkoutMO.fetchRequest()
        let workoutsTemplatesFetchRequest: NSFetchRequest<WorkoutMO> = WorkoutMO.fetchRequest()
        
        if let workouts = try? context.fetch(workoutsFetchRequest) {
            workouts.forEach({ context.delete($0) })
        }
        
        if let workoutsTemplates = try? context.fetch(workoutsTemplatesFetchRequest) {
            workoutsTemplates.forEach({ context.delete($0) })
        }
    }
    
    func setStart(for workout: WorkoutMO) {
        workout.startTimeDate = Date()
        saveContext()
    }
    
    func setFinish(for workout: WorkoutMO) {
        workout.endTimeDate = Date()
        saveContext()
    }
    
    var isTodayWorkoutExist: Bool {
        return fetchWorkouts(for: .today).first != nil ? true : false
    }
    
    func fetchWorkouts(for timePeriod: WorkoutService.TimePeriod) -> [WorkoutMO] {
        let predicate = timePeriod.predicate
        let sortDescriptotr = NSSortDescriptor(key: #keyPath(WorkoutMO.date), ascending: false)
        let fetchRequest: NSFetchRequest<WorkoutMO> = WorkoutMO.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptotr]
        guard let workouts = try? context.fetch(fetchRequest) else { return [] }
        return workouts
    }
    
    func deleteWorkout(workout: WorkoutMO) {
        context.delete(workout)
        saveContext()
    }
    
    func createWorkout(with exercises: [Exercise]) {
        let workout = WorkoutMO(context: context)
        var exercisesMO: [ExerciseMO] = []
        var displayID: Int64 = 0
        exercises.forEach({ exercise in
            let newExercise = ExerciseMO(context: context)
            newExercise.id = displayID
            newExercise.name = exercise.name
            newExercise.groupName = exercise.group.rawValue
            newExercise.subgroupName = exercise.subgroub.rawValue
            newExercise.workout = workout
            newExercise.date = Date()
            newExercise.isDone = false
            exercisesMO.append(newExercise)
            displayID += 1
        })
        workout.date = Date()
        workout.formatedDate = DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat)
        workout.exercises = NSSet(array: exercisesMO)
        saveContext()
    }
    
    func addExerciseToTodaysWorkout(exercise: [Exercise]) {
        guard let todayWorkout = fetchWorkouts(for: .today).first else { return }
        let exerciseInWorkout = todayWorkout.exercicesArray.map({ $0.name })
        let newExercises = exercise.filter({ exerciseInWorkout.contains($0.name) })
        var displayID: Int64 = 0
        var exercisesMO: [ExerciseMO] = []
        newExercises.forEach({ exercise in
            let newExercise = ExerciseMO(context: context)
            newExercise.id = displayID
            newExercise.name = exercise.name
            newExercise.groupName = exercise.group.rawValue
            newExercise.subgroupName = exercise.subgroub.rawValue
            newExercise.workout = todayWorkout
            newExercise.date = Date()
            newExercise.isDone = false
            exercisesMO.append(newExercise)
            displayID += 1
        })
        todayWorkout.addToExercises(NSSet(array: exercisesMO))
        saveContext()
    }
    
    func fetchExercise(for workout: WorkoutMO) -> [ExerciseMO] {
        let perdicate = NSPredicate(format: "workout == % @", workout)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ExerciseMO.name), ascending: true)
        let fetchRequest: NSFetchRequest<ExerciseMO> = ExerciseMO.fetchRequest()
        fetchRequest.predicate = perdicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let exericses = try? context.fetch(fetchRequest) else { return [] }
        return exericses
    }
    
    func syncWorkoutsFromFirebase(workouts: [TrainingCodableModel]) {
        for training in workouts {
            let newTrain = WorkoutMO(context: self.context)
            newTrain.formatedDate = training.formatedDate
            newTrain.date = training.date
            for exercice in training.exerciceArray {
                let newExercice = ExerciseMO(context: self.context)
                newExercice.name = exercice.name
                newExercice.isDone = exercice.isDone ?? false
                newExercice.subgroupName = exercice.subgroupName
                newExercice.groupName = exercice.groupName
                newExercice.id = Int64(exercice.id)
                newExercice.workout = newTrain
                newExercice.date = training.date
                newTrain.addToExercises(newExercice)
                for aproach in exercice.aproachlist {
                    let newAproah = ApproachMO(context: self.context)
                    
                    newAproah.weightValue = aproach.weight
                    newAproah.weightMode = aproach.weightMode
                    newAproah.index = aproach.index.int64
                    newAproah.reps = aproach.reps.int64
                    newAproah.exercise = newExercice
                    newExercice.addToApproaches(newAproah)
                }
            }
        }
        NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        self.saveContext()
    }
}
