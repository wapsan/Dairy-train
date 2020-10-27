import UIKit

final class MuscleSubgropsRouter: Router {
    
    private weak var rootViewController: MuscleSubgroupsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? MuscleSubgroupsViewController
    }
    
    func pushExerciseListViewController(with exerciselist: [Exercise],
                                        and subgroupTitle: String,
                                        target: TrainingEntityTarget) {
        let listViewController = self.configureExerciseListViewController(with: exerciselist,
                                                                          and: subgroupTitle,
                                                                          target: target)
        self.rootViewController?.navigationController?.pushViewController(listViewController,
                                                                          animated: true)
    }
}

private extension MuscleSubgropsRouter {
    
    func configureExerciseListViewController(with exerciseList: [Exercise],
                                             and subgroupTitle: String,
                                             target: TrainingEntityTarget) -> ExerciseListViewController {
        let exerciseListModel: ExerciseListModel
        switch target {
        case .training:
            exerciseListModel = ExerciseListModel(trainingPatern: nil)
        case .trainingPatern(trainingPatern: let trainingPatern):
            exerciseListModel = ExerciseListModel(trainingPatern: trainingPatern)
        }
        let exerciseListViewController = ExerciseListViewController(trainingEntityTarget: target)
        let exerciseViewModel = ExerciseListViewModel(with: exerciseList,
                                                      and: subgroupTitle)
        exerciseListViewController.viewModel = exerciseViewModel
        exerciseViewModel.model = exerciseListModel
        exerciseViewModel.view = exerciseListViewController
        exerciseListModel.output = exerciseViewModel
        return exerciseListViewController
    }
}
