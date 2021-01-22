import UIKit

final class CreatingTrainingModalConfigurator {
    
    static func configure(with delegate: CreatingTrainingModalRouterDelegate) -> CreteTrainingModalViewController {
        let createTrainingPopUpModel = CreatingTrainingModalModel()
        let createTrainingPopUpViewModel = CreatingTrainingModalViewModel(model: createTrainingPopUpModel)
        let createTrainingPopUpViewController = CreteTrainingModalViewController(viewModel: createTrainingPopUpViewModel)
        let createTrainingPopUpRouter = CreatingTrainingModelRouter(createTrainingPopUpViewController)
        createTrainingPopUpViewModel.router = createTrainingPopUpRouter
        createTrainingPopUpRouter.delegate = delegate
        return createTrainingPopUpViewController
    }
}
