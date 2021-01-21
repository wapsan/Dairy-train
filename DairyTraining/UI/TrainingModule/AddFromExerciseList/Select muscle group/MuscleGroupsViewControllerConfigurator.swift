import UIKit

final class MuscleGroupsViewControllerConfigurator {
    
    func configure(for trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupViewController = MuscleGroupsViewController(trainingEntityTarget: .training)
        let muscleGroupViewModel = MuscleGroupsViewModel()
        muscleGroupViewController.viewModel = muscleGroupViewModel
        return muscleGroupViewController
    }
}
