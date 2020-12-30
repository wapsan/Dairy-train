import Foundation

protocol TrainingProgramsLevelsModelProtocl {
    func dismissViewController()
    func pushTrainingPrograms(for levelOfTraining: LevelOfTrainingModel)
}

protocol TrainingProgramsLevelsModelOutput: AnyObject {
   
}

final class TrainingProgramsLevelsModel {
    
    weak var output: TrainingProgramsLevelsModelOutput?
}

// MARK: - TrainingProgramsLevelsModelProtocl
extension TrainingProgramsLevelsModel: TrainingProgramsLevelsModelProtocl {
    
    func pushTrainingPrograms(for levelOfTraining: LevelOfTrainingModel) {
        MainCoordinator.shared.coordinate(to: TrainingProgramsCoordinator.Target.trainings(levelOfTrainings: levelOfTraining))
    }
    
    func dismissViewController() {
        MainCoordinator.shared.dismiss()
    }
}

