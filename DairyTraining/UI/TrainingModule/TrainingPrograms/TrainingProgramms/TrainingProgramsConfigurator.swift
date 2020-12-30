import Foundation

struct TrainingProgramsConfigurator {
    
    static func configure(for levelOfTrinings: LevelOfTrainingModel) -> TrainingProgramsViewController {
        let model = TrainingProgramsModel(trainingLevel: levelOfTrinings)
        let viewModel = TrainingProgramsViewModel(model: model)
        let viewController = TrainingProgramsViewController(viewModel: viewModel)
        model.output = viewModel
        viewModel.view = viewController
        return viewController
    }
}
