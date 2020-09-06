import UIKit

final class MuscleGroupsRouter: Router {
    
    private weak var rootViewController: MuscleGroupsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? MuscleGroupsViewController
    }
    
    func pushMuscleSubgroupsGroupViewController(with subgroup: [MuscleSubgroup.Subgroup],
                                       and groupTitle: String) {
        let muscleSubgroupsViewController = self.configureMuscleSubgroupViewController(
            with: subgroup,
            and: groupTitle)
        self.rootViewController?.navigationController?.pushViewController(muscleSubgroupsViewController,
                                                                          animated: true)
    }
}

//MARK: - Private extension
private extension MuscleGroupsRouter {
    
    func configureMuscleSubgroupViewController(with subgroup: [MuscleSubgroup.Subgroup],
                                               and groupTitle: String) -> MuscleSubgroupsViewController {
        let subgroupListViewController = MuscleSubgroupsViewController()
        let subgroupListViewModel = MuscleSubgropsViewModel(with: subgroup, and: groupTitle)
        let subgroupListRouter = MuscleSubgropsRouter(subgroupListViewController)
        subgroupListViewModel.view = subgroupListViewController
        subgroupListViewController.viewModel = subgroupListViewModel
        subgroupListViewController.router = subgroupListRouter
        return subgroupListViewController
    }
}
