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
    
    func pushExerciseListViewController() {
        let muscularGroupViewController = self.configureMuscleVC()
        self.rootViewController?.navigationController?.pushViewController(muscularGroupViewController,
                                                                          animated: true)
    }
    
    func pushTrainingPaternsViewController() {
        let trainingPaternsViewController = self.configureTrainingPaternsViewController()
        self.rootViewController?.navigationController?.pushViewController(trainingPaternsViewController,
                                                                          animated: true)
    }
}

private extension TrainingListRouter {
    
    private func configureTrainingPaternsViewController() -> TrainingPaternsViewController {
        let trainingPaternsViewController = TrainingPaternsViewController()
        return trainingPaternsViewController
    }
    
    private func configureMuscleVC() -> MuscleGroupsViewController {
           let muscleGroupsVC = MuscleGroupsViewController()
           let muscleGroupsViewMode = MuscleGroupsViewModel()
           let muscleGroupsRouter = MuscleGroupsRouter(muscleGroupsVC)
           muscleGroupsVC.viewModel = muscleGroupsViewMode
           muscleGroupsVC.router = muscleGroupsRouter
           muscleGroupsViewMode.viewPresenter = muscleGroupsVC
           return muscleGroupsVC
           
       }
    
    private func configureTrainingViewController(for train: TrainingManagedObject) -> TrainingViewController {
        let trainingViewController = TrainingViewController()
        let trainingViewModel = TrainingViewModel()
        let trainingModel = TrainingModel(with: train)
        let trainingRouter = TrainingRouter(trainingViewController)
        trainingViewController.viewModel = trainingViewModel
        trainingViewModel.router = trainingRouter
        trainingViewModel.view = trainingViewController
        trainingViewModel.model = trainingModel
        trainingModel.output = trainingViewModel
        return trainingViewController
    }
}
