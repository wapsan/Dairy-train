import Foundation

protocol TrainingProgramsLevelsViewModelProtocol {
    var levelsOfTrainings: [LevelOfTrainingModel] { get }
    
    func levelOfTraining(for index: Int) -> LevelOfTrainingModel
    func didSelectRow(at index: Int)
    func backButtonPressed()
}

final class TrainingProgramsLevelsViewModel {

    weak var view: TrainingProgramsLevelsViewProtocol?
    private var model: TrainingProgramsLevelsModelProtocl
    private var _data: [SpecialWorkout] = []
    
    
    init(model: TrainingProgramsLevelsModelProtocl) {
        self.model = model
    }
    
}

// MARK: - TrainingProgramsLevelsViewModelProtocol
extension TrainingProgramsLevelsViewModel: TrainingProgramsLevelsViewModelProtocol {
    
    func didSelectRow(at index: Int) {
        model.pushTrainingPrograms(for: LevelOfTrainingModel.allCases[index])
    }
    
    func levelOfTraining(for index: Int) -> LevelOfTrainingModel {
        return LevelOfTrainingModel.allCases[index]
    }
    
    var levelsOfTrainings: [LevelOfTrainingModel] {
        return LevelOfTrainingModel.allCases
    }
    
    func backButtonPressed() {
        model.dismissViewController()
    }
}

// MARK: - TrainingProgramsLevelsModelOutput
extension TrainingProgramsLevelsViewModel: TrainingProgramsLevelsModelOutput {
    
}
