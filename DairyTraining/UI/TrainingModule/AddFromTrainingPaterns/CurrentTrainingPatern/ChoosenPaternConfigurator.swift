import Foundation

final class ChoosenPaternConfigurator {
    
    func configure(for trainingPaterm: TrainingPaternManagedObject) -> ChoosenPaternViewController {
        let choosenPaternModel = ChoosenPaternModel(patern: trainingPaterm)
        let choosenPaternViewModel = ChoosenPaternViewModel(model: choosenPaternModel)
        let choosenPaternViewController = ChoosenPaternViewController(viewModel: choosenPaternViewModel)
        let choosenPaternRouter = ChoosenPaternRouter(choosenPaternViewController)
        choosenPaternViewModel.view = choosenPaternViewController
        choosenPaternViewModel.router = choosenPaternRouter
        choosenPaternModel.output = choosenPaternViewModel
        return choosenPaternViewController
    }
}
