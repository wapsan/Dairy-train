import UIKit

final class MuscleSubgropsRouter: Router {
    
    private weak var rootViewController: MuscleSubgroupsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? MuscleSubgroupsViewController
    }
    
    func pushExerciseListViewController(with exerciselist: [Exercise], and subgroupTitle: String) {
        let listViewController = self.configureExerciseListViewController(with: exerciselist,
                                                                          and: subgroupTitle)
        self.rootViewController?.navigationController?.pushViewController(listViewController,
                                                                          animated: true)
    }
}

private extension MuscleSubgropsRouter {
    
    func configureExerciseListViewController(with exerciseList: [Exercise],
                                             and subgroupTitle: String) -> ExerciseListViewController {
        let exerciseListViewController = ExerciseListViewController()
        let exerciseViewModel = ExerciseListViewModel(with: exerciseList,
                                                      and: subgroupTitle)
        let exerciseListModel = ExerciseListModel()
        exerciseListViewController.viewModel = exerciseViewModel
        exerciseViewModel.model = exerciseListModel
        exerciseViewModel.view = exerciseListViewController
        exerciseListModel.output = exerciseViewModel
        return exerciseListViewController
    }
}
