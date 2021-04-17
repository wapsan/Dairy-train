import Foundation
import CoreData

protocol WorkoutInteractorProtocol: AnyObject {
    var isTrainingEditable: Bool { get }
    var currentWorkout: WorkoutMO { get }
    var exercises: [ExerciseMO] { get }
    
    func deleteExercice(at indexPath: IndexPath)
    
    func startWorkout()
    func stopWorkout()
}

protocol WorkoutModelOutput: AnyObject {
    
    func trainingWasChange()
    func trainingIsEmpty()
    
    //MARK: - New
    func deleteExercise(at indexPath: IndexPath)
    func insertExercise(at indexPath: IndexPath)
    func updateStartTime(time: Date)
    func updateEndTime(time: Date)
}

final class WorkoutIneractor {
    
    //MARK: - Internal properties
    weak var output: WorkoutModelOutput?
    
    //MARK: - Private properties
    private var workout: WorkoutMO
    private var _exercise: [ExerciseMO] = []
    private let persistenceService: PersistenceService

    //MARK: - Initialization
    init(with train: WorkoutMO, service: PersistenceService = PersistenceService()) {
        self.workout = train
        self.persistenceService = service
        self._exercise = persistenceService.workout.fetchExercise(for: workout)
 
        registerObserverForTrainingChanging()
    }
    
    //MARK: - Private methods
    private func registerObserverForTrainingChanging() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasChanged),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    @objc private func trainingWasChanged() {
        let exercise = persistenceService.workout.fetchExercise(for: workout)
        exercise.forEach({ exercise in
            if !_exercise.contains(exercise) {
                _exercise.append(exercise)
                output?.insertExercise(at: IndexPath(row: _exercise.count - 1, section: 0))
            }
        })
    }
}

//MARK: - TrainingModelIteracting
extension WorkoutIneractor: WorkoutInteractorProtocol {


    func deleteExercice(at indexPath: IndexPath) {
        let exercise = _exercise[indexPath.row]
        _exercise.remove(at: indexPath.row)
        persistenceService.exercise.deleteExercise(exercise: exercise)
        output?.deleteExercise(at: indexPath)
    }
    
    func exercise(at indexPath: IndexPath) -> ExerciseMO {
        return _exercise[indexPath.row]
    }
    
    var exercises: [ExerciseMO] {
        _exercise
    }
    
    
    func startWorkout() {
        persistenceService.workout.setStart(for: workout)
        output?.updateStartTime(time: Date())
    }
    
    func stopWorkout() {
        persistenceService.workout.setFinish(for: workout)
        output?.updateEndTime(time: Date())
    }
    
    var currentWorkout: WorkoutMO {
        return workout
    }
    
    var isTrainingEditable: Bool {
        return workout.isEditable
    }
}
