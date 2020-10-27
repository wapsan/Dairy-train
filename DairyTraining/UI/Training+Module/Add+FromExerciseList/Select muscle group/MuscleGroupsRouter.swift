import UIKit

final class MuscleGroupsRouter: Router {
    
    private weak var rootViewController: MuscleGroupsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? MuscleGroupsViewController
    }
    
    func pushMuscleSubgroupsGroupViewController(with subgroup: [MuscleSubgroup.Subgroup],
                                       and groupTitle: String,
                                       target: TrainingEntityTarget) {
        let muscleSubgroupsViewController = self.configureMuscleSubgroupViewController(
            with: subgroup,
            and: groupTitle,
            target: target)
        self.rootViewController?.navigationController?.pushViewController(muscleSubgroupsViewController,
                                                                          animated: true)
    }
}

//MARK: - Private extension
private extension MuscleGroupsRouter {
    
    func configureMuscleSubgroupViewController(with subgroup: [MuscleSubgroup.Subgroup],
                                               and groupTitle: String,
                                               target: TrainingEntityTarget) -> MuscleSubgroupsViewController {
        let subgroupListViewController = MuscleSubgroupsViewController(trainingEntityTarget: target)
        let subgroupListViewModel = MuscleSubgropsViewModel(with: subgroup, and: groupTitle)
        let subgroupListRouter = MuscleSubgropsRouter(subgroupListViewController)
        subgroupListViewModel.view = subgroupListViewController
        subgroupListViewController.viewModel = subgroupListViewModel
        subgroupListViewController.router = subgroupListRouter
        return subgroupListViewController
    }
}
