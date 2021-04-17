import Foundation

protocol WorkoutPresenterProtocol {
    
    var trainingDate: String? { get }
    var exerciseCount: Int { get }
    var isTrainingEditable: Bool { get }
    var startTime: Date? { get }
    var endTime: Date? { get }
    
    func item(at indexPath: IndexPath) -> ExerciseMO
    
    func tryDeleteExercice(at indexPath: IndexPath)
        
    func exeriseStatisticsButtonPressed(at indexPath: IndexPath)
    
    func isExerciseEditable(at index: Int) -> Bool
    func footerButtonPressed()
    func statisticsButtonPressed()
    
    func startWotkout()
    func stopWorkout()
    
    func backButtonPressed() 
}

final class WorkoutPresenter {
    
    // MARK: - Internal Properties
    var router: WorkoutRouterProtocol?
    weak var view: WorkoutViewProtocol?
    
    // MARK: - Properties
    private var interactor: WorkoutInteractorProtocol
    
    // MARK: - Initialization
    init(model: WorkoutInteractorProtocol) {
        self.interactor = model
    }
}

//MARK: - TrainingModelOutput
extension WorkoutPresenter: WorkoutModelOutput {
    
    func updateStartTime(time: Date) {
        view?.updateStartWorkout()
    }
    
    func updateEndTime(time: Date) {
        view?.updateEndWorkout()
    }
    
    func insertExercise(at indexPath: IndexPath) {
        view?.insertRow(at: indexPath)
    }
    
    func deleteExercise(at indexPath: IndexPath) {
        view?.deleteRow(at: indexPath)
    }

    func trainingIsEmpty() {
        router?.popViewController()
    }
    
    func trainingWasChange() {
        self.view?.reloadTable()
    }
}

//MARK: - TrainingViewModeIteracting
extension WorkoutPresenter: WorkoutPresenterProtocol {
    
    func exeriseStatisticsButtonPressed(at indexPath: IndexPath) {
        let exercise = interactor.exercises[indexPath.row]
        router?.showExerciseHistoryStatisticsScreen(for: exercise)
    }
    
    func item(at indexPath: IndexPath) -> ExerciseMO {
        interactor.exercises[indexPath.row]
    }
    
    var exerciseCount: Int {
        interactor.exercises.count
    }
    
    func startWotkout() {
        interactor.startWorkout()
    }
    
    func stopWorkout() {
        interactor.stopWorkout()
    }
    
    var startTime: Date? {
        interactor.currentWorkout.startTimeDate
    }
    
    var endTime: Date? {
        interactor.currentWorkout.endTimeDate
    }
    
    func backButtonPressed() {
        router?.popViewController()
    }
    
    func statisticsButtonPressed() {
        router?.showCurrentWorkoutStatisticsScreen(for: interactor.currentWorkout)
    }
    
    var isTrainingEditable: Bool {
        return interactor.isTrainingEditable
    }
    
    func footerButtonPressed() {
        router?.presentExerciseFlow()
    }
    
    func isExerciseEditable(at index: Int) -> Bool {
        return interactor.exercises[index].isDone
    }

    var trainingDate: String? {
        return interactor.currentWorkout.formatedDate
    }
    
    func tryDeleteExercice(at indexPath: IndexPath) {
        let exerciseNameForDeleting = interactor.exercises[indexPath.row]
        router?.showAlert(title: "Delete \(exerciseNameForDeleting.name)?",
                          message: "Are you sure?",
                          completion: { [weak self] in self?.interactor.deleteExercice(at: indexPath)})
    }
}
 
