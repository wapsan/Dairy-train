import UIKit

struct WorkoutListViewControllerConfigurator {
    
    static func configure() -> WorkoutListViewController {
        let workoutListModel = WorkoutListModel()
        let workOutListViewModel = WorkoutListViewModel(model: workoutListModel)
        let workOutListViewController = WorkoutListViewController(viewModel: workOutListViewModel)
        let workoutListRouter = WorkoutListRouter(workOutListViewController)
        workoutListModel.output = workOutListViewModel
        workOutListViewModel.view = workOutListViewController
        workOutListViewModel.router = workoutListRouter
        return workOutListViewController
    }
    
    static func configureWorkoutModule() -> UINavigationController {
        let workoutListModel = WorkoutListModel()
        let workOutListViewModel = WorkoutListViewModel(model: workoutListModel)
        let workOutListViewController = WorkoutListViewController(viewModel: workOutListViewModel)
        let workoutListRouter = WorkoutListRouter(workOutListViewController)
        workoutListModel.output = workOutListViewModel
        workOutListViewModel.view = workOutListViewController
        workOutListViewModel.router = workoutListRouter
        let navigationController = UINavigationController(rootViewController: workOutListViewController)
        navigationController.tabBarItem = MainTabBarModel.Item.training.item
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
}
