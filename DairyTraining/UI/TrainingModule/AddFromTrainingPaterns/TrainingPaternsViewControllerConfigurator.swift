import UIKit

final class TrainingPaternsViewControllerConfigurator {
    
    func configure() -> TrainingPaternsViewController {
        let trainingPaternModel = TrainingPaterModel()
        let trainingPaternViewModel = TrainingPaternViewModel(model: trainingPaternModel)
        let trainingPaternsViewController = TrainingPaternsViewController(viewModel: trainingPaternViewModel)
        let trainingPaternsRouter = TrainingPaternsRouter(trainingPaternsViewController)
        trainingPaternViewModel.router = trainingPaternsRouter
        trainingPaternViewModel.view = trainingPaternsViewController
        trainingPaternModel.output = trainingPaternViewModel
        return trainingPaternsViewController
    }
}
