import Foundation

protocol TrainingProgramsModelProtocol {
    var levelOfTraining: LevelOfTrainingModel { get }
    
    func loadData()
    func popViewController()
    func pushSpecialWorkoutViewController(for specialWorkout: SpecialWorkout)
}

protocol TrainingProgramsModelOutput: AnyObject {
    func updateTrainings(for trainings: [SpecialWorkout])
}

final class TrainingProgramsModel {
    
    // MARK: - Module properties
    weak var output: TrainingProgramsModelOutput?
    
    // MARK: - Private properties
    private var _levelOfTraining: LevelOfTrainingModel
    
    private var dataBaseService = FirebaseStorageMnager()
    
    // MARK: - Initialization
    init(trainingLevel: LevelOfTrainingModel) {
        self._levelOfTraining = trainingLevel
    }
}

// MARK: - TrainingProgramsModelProtocol
extension TrainingProgramsModel: TrainingProgramsModelProtocol {
    
    func pushSpecialWorkoutViewController(for specialWorkout: SpecialWorkout) {
        MainCoordinator.shared.coordinate(to: TrainingProgramsCoordinator.Target.workout(workout: specialWorkout))
    }
    
    func popViewController() {
        MainCoordinator.shared.popViewController()
    }
    
    var levelOfTraining: LevelOfTrainingModel {
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
