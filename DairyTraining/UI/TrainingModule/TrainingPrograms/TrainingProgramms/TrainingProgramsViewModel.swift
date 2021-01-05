import Foundation

protocol TrainingProgramsViewModelProtocol {
    var trainings: [SpecialWorkout] { get }
    var levelTitle: String { get }
    var levelDescription: String { get }
    
    func viewDidLoad()
    func getTraining(for index: Int) -> SpecialWorkout
    func backButtonPressed()
    func didSelectRow(at index: Int)
}

final class TrainingProgramsViewModel {
    
    // MARK: - Module Properties
    weak var view: TrainingProgramsViewProtocol?
    private let model: TrainingProgramsModelProtocol
    
    // MARK: - Properties
    private var _trainings: [SpecialWorkout] = []
    
    // MARK: - Initialization
    init(model: TrainingProgramsModelProtocol) {
        self.model = model
    }
}

// MARK: - TrainingProgramsViewModelProtocol
extension TrainingProgramsViewModel: TrainingProgramsViewModelProtocol {
    
    func didSelectRow(at index: Int) {
        model.pushSpecialWorkoutViewController(for: _trainings[index])
    }

    func getTraining(for index: Int) -> SpecialWorkout {
        return _trainings[index]
    }
    
    func backButtonPressed() {
        model.popViewController()
    }
    
    var levelDescription: String {
        return model.levelOfTraining.description
    }
    
    var levelTitle: String {
        return model.levelOfTraining.title
    }
    
    func viewDidLoad() {
        view?.showLoader()
        model.loadData()
    }
    
    var trainings: [SpecialWorkout] {
        return _trainings
    }
}

// MARK: - TrainingProgramsModelOutput
extension TrainingProgramsViewModel: TrainingProgramsModelOutput {
    
    func updateTrainings(for trainings: [SpecialWorkout]) {
        _trainings = trainings
        view?.hideLoader()
        view?.reloadTableView()
    }
}
