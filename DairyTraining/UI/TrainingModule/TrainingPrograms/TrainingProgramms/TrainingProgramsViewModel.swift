import Foundation

protocol TrainingProgramsViewModelProtocol {
    var trainings: [TrainingProgramms] { get }
    var levelTitle: String { get }
    var levelDescription: String { get }
    
    func viewDidLoad()
    func getTraining(for index: Int) -> TrainingProgramms
    func backButtonPressed()
}

final class TrainingProgramsViewModel {
    
    // MARK: - Module Properties
    weak var view: TrainingProgramsViewProtocol?
    private let model: TrainingProgramsModelProtocol
    
    // MARK: - Properties
    private var _trainings: [TrainingProgramms] = []
    
    // MARK: - Initialization
    init(model: TrainingProgramsModelProtocol) {
        self.model = model
    }
}

// MARK: - TrainingProgramsViewModelProtocol
extension TrainingProgramsViewModel: TrainingProgramsViewModelProtocol {
    
    func getTraining(for index: Int) -> TrainingProgramms {
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
    
    var trainings: [TrainingProgramms] {
        return _trainings
    }
}

// MARK: - TrainingProgramsModelOutput
extension TrainingProgramsViewModel: TrainingProgramsModelOutput {
    
    func updateTrainings(for trainings: [TrainingProgramms]) {
        _trainings = trainings
        view?.hideLoader()
        view?.reloadTableView()
    }
}
