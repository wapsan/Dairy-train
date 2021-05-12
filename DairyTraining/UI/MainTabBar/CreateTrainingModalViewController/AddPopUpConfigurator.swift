import UIKit

final class CreatingTrainingModalConfigurator {
    
    static func configure(for option: AddPopUpInteractor.AddingOptionType) -> AddPopUpViewController {
        let createTrainingPopUpModel = AddPopUpInteractor(optionType: option)
        let createTrainingPopUpViewModel = AddPopUpPresenter(interactor: createTrainingPopUpModel)
        let createTrainingPopUpViewController = AddPopUpViewController(presenter: createTrainingPopUpViewModel)
        let createTrainingPopUpRouter = AddPopUpRouter(createTrainingPopUpViewController)
        createTrainingPopUpViewModel.router = createTrainingPopUpRouter
        return createTrainingPopUpViewController
    }
}
