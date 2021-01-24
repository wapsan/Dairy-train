import Foundation

final class TrainingProgramsLevelsConfigurator {
    
    func configure() -> TrainingProgramsLevelsViewController {
        let model = TrainingLevelsModel()
        let viewModel = TrainingProgramsLevelsViewModel(model: model)
        let viewController = TrainingProgramsLevelsViewController(viewModel: viewModel)
        let router = TrainingLevelsRouter(viewController)
        viewModel.router = router
        model.output = viewModel
        viewModel.view = viewController
        return viewController
    }
}
