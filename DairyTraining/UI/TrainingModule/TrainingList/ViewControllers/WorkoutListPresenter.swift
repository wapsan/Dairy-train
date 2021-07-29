import Foundation

protocol TitledScreenProtocol {
    var title: String { get }
    var description: String { get }
}

protocol WorkoutListView {
    func reloadTable()
}

protocol WorkoutListPresenterProtocol: TitledScreenProtocol {
    var workoutsCount: Int { get }
    func item(at indexPath: IndexPath) -> WorkoutMO
    func segmentControlIndexDidChange(index: Int)
    func didSelectItem(at indexPath: IndexPath)
    func swipeRow(at indexPath: IndexPath)
    
    var isTrainingExists: Bool { get }
}

final class WorkoutListPresenter {

    //MARK: - Internal properties
    weak var view: WorkoutListViewProtocol?
    var router: WorkoutListRouterProtocol?
    
    // MARK: - Module properties
    private let interactor: WorkoutListInteractorProtocol
    
    // MARK: - Initialization
    init(model: WorkoutListInteractorProtocol) {
        self.interactor = model
    }
}

// MARK: - WorkoutListViewModelProtocol
extension WorkoutListPresenter: WorkoutListPresenterProtocol {
    
    var isTrainingExists: Bool {
        return !interactor.workouts.isEmpty
    }
    
    var workoutsCount: Int {
        return interactor.workouts.isEmpty ? 1 : interactor.workouts.count
    }

    func swipeRow(at indexPath: IndexPath) {
        interactor.deleteWorkout(at: indexPath)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard isTrainingExists else { return }
        let workout = interactor.item(at: indexPath)
        router?.showChoosenWorkoutScreen(for: workout)
    }
    
    func segmentControlIndexDidChange(index: Int) {
        guard let timePeriod = WorkoutService.TimePeriod(rawValue: index) else { return }
        interactor.timePeriodDidChande(timePeriod: timePeriod)
    }
    
    func item(at indexPath: IndexPath) -> WorkoutMO {
        interactor.item(at: indexPath)
    }
    
    var title: String {
        return "Workouts"
    }
    
    var description: String {
        return "Here is history list of all you workouts, each workout contains detailed training  information about it."
    }
}

// MARK: - WorkoutListModelOutput
extension WorkoutListPresenter: WorkoutListInteractorOutput {
    
    func workoutWasDeleted(at indexPath: IndexPath) {
        view?.deleteRow(at: indexPath)
    }
    
    func insertWorkout(at indexPath: IndexPath) {
        view?.inserRow(at: indexPath)
    }
    
    func workoutsUpdate() {
        view?.reloadData()
    }
}
