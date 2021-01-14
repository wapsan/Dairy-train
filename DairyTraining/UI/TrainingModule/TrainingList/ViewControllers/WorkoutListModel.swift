import Foundation

protocol WorkoutListModelProtocol {
    var workouts: [TrainingManagedObject] { get }
    var errorMessage: String { get }
    
    func loadWorkouts(for index: Int)
    func deleteWorkout(at index: Int)
    func pushWorkoutScreen(for workout: TrainingManagedObject)
}

protocol WorkoutListModelOutput: AnyObject {
    func workoutsUpdate()
    func workoutWasDeleted(at index: Int)
}

final class WorkoutListModel {
    
    // MARK: - Types
    enum WorkoutsForTimeRange: Int {
        case today
        case week
        case month
        case allTime
        
        var workouts: [TrainingManagedObject] {
            switch self {
            case .today:
                return TrainingDataManager.shared.todaysWorkout()
            case .week:
                return TrainingDataManager.shared.weekWorkouts()
            case .month:
                return TrainingDataManager.shared.mounthWorkouts()
            case .allTime:
                return TrainingDataManager.shared.getTraingList()
            }
        }
        
        var emptyErrorMessage: String {
            switch self {
            
            case .today:
                return "You have no training this day"
            case .week:
                return "You have no training on this week"
            case .month:
                return "You have no training on this month"
            case .allTime:
                return "You have no training yet"
            }
        }
    }
    
    // MARK: - Module Properties
    weak var output: WorkoutListModelOutput?
    
    // MARK: - Private properties
    private var _errorMessage: String = WorkoutsForTimeRange.today.emptyErrorMessage
    private var _workouts: [TrainingManagedObject] = [] {
        didSet {
            output?.workoutsUpdate()
        }
    }
    
    // MARK: - Initialization
    init() {
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
        _workouts = WorkoutsForTimeRange.today.workouts
        output?.workoutsUpdate()
    }
    
    @objc private func workoutWasChanged() {
        _workouts = WorkoutsForTimeRange.today.workouts
        output?.workoutsUpdate()
    }
}

// MARK: - WorkoutListModelProtocol
extension WorkoutListModel: WorkoutListModelProtocol {
    
    var errorMessage: String {
        return _errorMessage
    }
    
    func deleteWorkout(at index: Int) {
        let dateOfWorkoutForDeleting = _workouts[index].date
        TrainingDataManager.shared.removeWorkout(with: dateOfWorkoutForDeleting)
        _workouts.remove(at: index)
        _workouts.isEmpty ? output?.workoutsUpdate() : output?.workoutWasDeleted(at: index)
    }
    
    func pushWorkoutScreen(for workout: TrainingManagedObject) {
        MainCoordinator.shared.coordinate(to: TrainingModuleCoordinator.Target.choosenTraining(training: workout))
    }
    
    func loadWorkouts(for index: Int) {
        guard let timePeriod = WorkoutsForTimeRange.init(rawValue: index) else { return }
        _workouts = timePeriod.workouts
        _errorMessage = timePeriod.emptyErrorMessage
    }
    
    var workouts: [TrainingManagedObject] {
        return _workouts
    }
}
