import Foundation

struct TrainingProgramsLevelsConfigurator {
    
    static func configure() -> TrainingProgramsLevelsViewController {
        let model = TrainingProgramsLevelsModel()
        let viewModel = TrainingProgramsLevelsViewModel(model: model)
        let viewController = TrainingProgramsLevelsViewController(viewModel: viewModel)
        model.output = viewModel
        viewModel.view = viewController
        return viewController
    }
}
