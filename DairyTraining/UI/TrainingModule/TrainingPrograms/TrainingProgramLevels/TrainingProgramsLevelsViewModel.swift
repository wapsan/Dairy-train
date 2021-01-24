import Foundation

protocol TrainingProgramsLevelsViewModelProtocol {
    var levelsOfTrainings: [TrainingLevelsModel.Level] { get }
    
    func levelOfTraining(for index: Int) -> TrainingLevelsModel.Level
    func didSelectRow(at index: Int)
    func backButtonPressed()
}

final class TrainingProgramsLevelsViewModel {

    var router: TrainingLevelsRouterProtocol?
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
        let selectedLevel = levelsOfTrainings[index]
        router?.showWorkoutsScreen(for: selectedLevel)
    }
    
    func backButtonPressed() {
        router?.hideReadyWorkoutsFlow()
    }
    
    func levelOfTraining(for index: Int) -> TrainingLevelsModel.Level {
        return TrainingLevelsModel.Level.allCases[index]
    }
    
    var levelsOfTrainings: [TrainingLevelsModel.Level] {
        return TrainingLevelsModel.Level.allCases
    }
}

// MARK: - TrainingProgramsLevelsModelOutput
extension TrainingProgramsLevelsViewModel: TrainingProgramsLevelsModelOutput {
    
}
