import Foundation
import CoreData

protocol WorkoutListInteractorProtocol {
    
    func item(at indexPath: IndexPath) -> WorkoutMO
    func timePeriodDidChande(timePeriod: WorkoutService.TimePeriod)
    func deleteWorkout(at indexPath: IndexPath)
    
    var workouts: [WorkoutMO] { get }
}

protocol WorkoutListInteractorOutput: AnyObject {
    func workoutsUpdate()
    func workoutWasDeleted(at indexPath: IndexPath)
    func insertWorkout(at indexPath: IndexPath)
}

final class WorkoutListInteractor {
    
    // MARK: - Internal Properties
    weak var output: WorkoutListInteractorOutput?
    
    // MARK: - Private properties
    private var persistenceService: PersistenceService
    private var _errorMessage: String = "Fix time period error empty state"
    
    private var _workouts: [WorkoutMO] = []
    
    private var _selectedPeriod: WorkoutService.TimePeriod = .today
    
    // MARK: - Initialization
    init(persistenceService: PersistenceService = PersistenceService()) {
        self.persistenceService = persistenceService
        
        _workouts = persistenceService.workout.fetchWorkouts(for: _selectedPeriod)
        
        addWorkoutChangesObservers()
    }
    
    private func addWorkoutChangesObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(workoutCreated),
                                               name: .trainingListWasChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(workoutWasChanged),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    @objc private func workoutCreated() {
        guard _selectedPeriod == .today else { return }
        _workouts = persistenceService.workout.fetchWorkouts(for: _selectedPeriod)
        output?.workoutsUpdate()
    }
    
    @objc private func workoutWasChanged() {
        guard _selectedPeriod == .today else { return }
        _workouts = persistenceService.workout.fetchWorkouts(for: _selectedPeriod)
        output?.workoutsUpdate()
    }
}

// MARK: - WorkoutListModelProtocol
extension WorkoutListInteractor: WorkoutListInteractorProtocol {
    
    var workouts: [WorkoutMO] {
        return _workouts
    }
    
    func deleteWorkout(at indexPath: IndexPath) {
        let workout = _workouts[indexPath.row]
        _workouts.remove(at: indexPath.row)
        
        persistenceService.workout.deleteWorkout(workout: workout)
        
        _workouts.isEmpty ? output?.workoutsUpdate() : output?.workoutWasDeleted(at: indexPath)
    }

    func timePeriodDidChande(timePeriod: WorkoutService.TimePeriod) {
        _workouts = []
        _workouts = persistenceService.workout.fetchWorkouts(for: timePeriod)
        _selectedPeriod = timePeriod
        
        output?.workoutsUpdate()
    }
    
    func item(at indexPath: IndexPath) -> WorkoutMO {
        return workouts[indexPath.row]
    }
}
