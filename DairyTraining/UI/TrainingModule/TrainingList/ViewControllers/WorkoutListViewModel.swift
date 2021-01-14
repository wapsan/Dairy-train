import Foundation

protocol TitledScreenProtocol {
    var title: String { get }
    var description: String { get }
}

protocol WorkoutListViewModelProtocol: TitledScreenProtocol {
    var workoutsCount: Int { get }
    var isTrainingExists: Bool { get }
    var emptyWorkoutsErrorMessage: String { get }
 
    func viewDidLoad()
    func getWorkout(for index: Int) -> TrainingManagedObject
    func changeTimePeriodIndexTo(index: Int)
    func selectRow(at index: Int)
    func swipeRow(at index: Int)
}

final class WorkoutListViewModel {

    // MARK: - Module properties
    private let model: WorkoutListModelProtocol
    weak var view: WorkoutListViewProtocol?
    
    // MARK: - Initialization
    init(model: WorkoutListModelProtocol) {
        self.model = model
    }
}

// MARK: - WorkoutListViewModelProtocol
extension WorkoutListViewModel: WorkoutListViewModelProtocol {
    
    var title: String {
        return "Workouts"
    }
    
    var description: String {
        return "Here is history list of all you workouts, each workout contains detailed training  information about it."
    }
    
    var emptyWorkoutsErrorMessage: String {
        return model.errorMessage
    }

    var isTrainingExists: Bool {
        return !model.workouts.isEmpty
    }
    
    func viewDidLoad() {
        model.loadWorkouts(for: 0)
    }
    
    func swipeRow(at index: Int) {
        model.deleteWorkout(at: index)
    }
    
    func selectRow(at index: Int) {
        guard isTrainingExists else { return }
        model.pushWorkoutScreen(for: model.workouts[index])
    }
    
    func changeTimePeriodIndexTo(index: Int) {
        model.loadWorkouts(for: index)
    }
    
    var workoutsCount: Int {
        return isTrainingExists ? model.workouts.count : 1
    }
    
    func getWorkout(for index: Int) -> TrainingManagedObject {
        return model.workouts[index]
    }
}

// MARK: - WorkoutListModelOutput
extension WorkoutListViewModel: WorkoutListModelOutput {
    
    func workoutWasDeleted(at index: Int) {
        view?.deleteRow(at: index)
    }
    
    func workoutsUpdate() {
        view?.reloadData()
    }
}
