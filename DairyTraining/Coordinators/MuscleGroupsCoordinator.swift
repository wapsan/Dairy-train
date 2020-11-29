
import UIKit

final class MuscleGroupsCoordinator: Coordinator {

    // MARK: - Types

    enum Target: CoordinatorTarget {
        case muscularGrops(patern: TrainingEntityTarget)
        case new(muscularGroup: MuscleGroup.Group, trainingEntityTarget: TrainingEntityTarget)
    }
    
    // MARK: - Properties

    var window: UIWindow?
    private var navigationController: UINavigationController?
    
    // MARK: - Init

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        case .muscularGrops(let trainingEntityTarget):
            let navigationController = UINavigationController(rootViewController: configureMuscleGroupViewController(with: trainingEntityTarget))
            navigationController.modalPresentationStyle = .fullScreen
            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
            self.navigationController = navigationController
        case .new(muscularGroup: let muscularGroup, trainingEntityTarget: let trainingEntityTarget):
            let exerciseNewModel = SelectExerciseNewModel(muscularGroup: muscularGroup,
                                                              trainingEntityTarget: trainingEntityTarget)
            let exerciseNewViewModel = SelectExerciseNewViewModel(model: exerciseNewModel)
            let exerciseNewViewController = SelectExerciseNewViewController(viewModel: exerciseNewViewModel)
            exerciseNewModel.viewModel = exerciseNewViewModel
            exerciseNewViewModel.view = exerciseNewViewController
            navigationController?.pushViewController(exerciseNewViewController, animated: true)
        }
        return true
    }
    
    
    // MARK: - Configuration methods
    private func configureMuscleGroupViewController(with trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupViewController = MuscleGroupsViewController(trainingEntityTarget: trainingEntityTarget)
        let muscleGroupViewModel = MuscleGroupsViewModel()
        muscleGroupViewController.viewModel = muscleGroupViewModel
        return muscleGroupViewController
    }
}
