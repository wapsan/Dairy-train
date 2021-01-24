import Foundation

protocol TrainingProgramsModelProtocol {
    var levelOfTraining: TrainingLevelsModel.Level { get }
    
    func loadData()
}

protocol TrainingProgramsModelOutput: AnyObject {
    func updateTrainings(for trainings: [SpecialWorkout])
}

final class TrainingProgramsModel {
    
    // MARK: - Module properties
    weak var output: TrainingProgramsModelOutput?
    
    // MARK: - Private properties
    private var _levelOfTraining: TrainingLevelsModel.Level
    
    private var dataBaseService = FirebaseStorageMnager()
    
    // MARK: - Initialization
    init(trainingLevel: TrainingLevelsModel.Level) {
        self._levelOfTraining = trainingLevel
    }
}

// MARK: - TrainingProgramsModelProtocol
extension TrainingProgramsModel: TrainingProgramsModelProtocol {
    
    var levelOfTraining: TrainingLevelsModel.Level {
        return _levelOfTraining
    }
    
    func loadData() {
        dataBaseService.getListOfTraining(for: _levelOfTraining) { [unowned self] (result) in
            switch result {
            case .success(let trainings):
                self.output?.updateTrainings(for: trainings)
            case .failure(_):
                break
            }
        }
    }
}
