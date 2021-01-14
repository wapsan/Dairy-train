import UIKit

struct WorkoutListViewControllerConfigurator {
    
    static func configure() -> WorkoutListViewController {
        let workoutListModel = WorkoutListModel()
        let workOutListViewModel = WorkoutListViewModel(model: workoutListModel)
        let workOutListViewController = WorkoutListViewController(viewModel: workOutListViewModel)
        workoutListModel.output = workOutListViewModel
        workOutListViewModel.view = workOutListViewController
        return workOutListViewController
    }
}
