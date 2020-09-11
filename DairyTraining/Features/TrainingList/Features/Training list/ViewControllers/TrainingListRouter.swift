import UIKit

final class TrainingListRouter: Router {
    
    weak var rootViewController: TrainingListViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? TrainingListViewController
    }
    
    func pushTrainingViewController(for training: TrainingManagedObject) {
        let trainingViewController = self.configureTrainingViewController(for: training)
        self.rootViewController?.navigationController?.pushViewController(trainingViewController,
                                                                          animated: true)
    }
}

private extension TrainingListRouter {
    
    private func configureTrainingViewController(for train: TrainingManagedObject) -> TrainingViewController {
        let trainingViewController = TrainingViewController()
        let trainingViewModel = TrainingViewModel()
        let trainingModel = TrainingModel(with: train)
        trainingViewController.viewModel = trainingViewModel
        trainingViewModel.view = trainingViewController
        trainingViewModel.model = trainingModel
        trainingModel.output = trainingViewModel
        return trainingViewController
    }
}
