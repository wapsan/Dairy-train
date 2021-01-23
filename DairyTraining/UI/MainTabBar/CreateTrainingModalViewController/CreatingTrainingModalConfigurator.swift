import UIKit

final class CreatingTrainingModalConfigurator {
    
    static func configure() -> CreteTrainingModalViewController {
        let createTrainingPopUpModel = CreatingTrainingModalModel()
        let createTrainingPopUpViewModel = CreatingTrainingModalViewModel(model: createTrainingPopUpModel)
        let createTrainingPopUpViewController = CreteTrainingModalViewController(viewModel: createTrainingPopUpViewModel)
        let createTrainingPopUpRouter = CreatingTrainingModelRouter(createTrainingPopUpViewController)
        createTrainingPopUpViewModel.router = createTrainingPopUpRouter
        return createTrainingPopUpViewController
    }
}
