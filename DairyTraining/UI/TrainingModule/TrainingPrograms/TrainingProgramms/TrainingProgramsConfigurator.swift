import Foundation

struct TrainingProgramsConfigurator {
    
    static func configure(for levelOfTrinings: TrainingLevelsModel.Level) -> TrainingProgramsViewController {
        let model = TrainingProgramsModel(trainingLevel: levelOfTrinings)
        let viewModel = TrainingProgramsViewModel(model: model)
        let viewController = TrainingProgramsViewController(viewModel: viewModel)
        let router = TrainingProgramsRouter(viewController)
        viewModel.router = router
        model.output = viewModel
        viewModel.view = viewController
        return viewController
    }
}
