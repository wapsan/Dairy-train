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
        let muscularGroupViewController = self.configureMuscleVC(with: .training)
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
        let trainingPaternModel = TrainingPaterModel()
        let trainingPaternViewModel = TrainingPaternViewModel(model: trainingPaternModel)
        let trainingPaternsViewController = TrainingPaternsViewController(viewModel: trainingPaternViewModel)
        let trainingPaternRouter = TrainingPaternRouter(trainingPaternsViewController)
        trainingPaternViewModel.router = trainingPaternRouter
        return trainingPaternsViewController
    }
    
    private func configureMuscleVC(with trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupsVC = MuscleGroupsViewController(trainingEntityTarget: trainingEntityTarget)
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
