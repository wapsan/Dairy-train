import Foundation

protocol TrainingProgramsViewModelProtocol {
    var trainings: [TrainingProgramms] { get }
    func viewDidLoad()
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
