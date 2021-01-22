import UIKit

final class MuscleGroupsViewControllerConfigurator {
    
    func configure(for trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupViewController = MuscleGroupsViewController(trainingEntityTarget: trainingEntityTarget)
        let muscleGroupViewModel = MuscleGroupsViewModel()
        let miscleGroupRouter = MuscleGroupRouter(muscleGroupViewController)
        muscleGroupViewModel.router = miscleGroupRouter
        muscleGroupViewController.viewModel = muscleGroupViewModel
        return muscleGroupViewController
    }
}
