import UIKit

protocol MuscleGroupRouterProtocol {
    func showExerciseListViewController(for muscleGroup: MuscleGroup.Group, and trainingEntityTarge: TrainingEntityTarget)
    func closeExerciseFlow()
}

final class MuscleGroupRouter: Router {
   
    // MARK: - Private properties
    private let rootViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - SelectExerciseRouterProtocol
extension MuscleGroupRouter: MuscleGroupRouterProtocol {
    
    func closeExerciseFlow() {
        rootViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showExerciseListViewController(for muscleGroup: MuscleGroup.Group, and trainingEntityTarge: TrainingEntityTarget) {
        let selesctExerciseViewController = SelectExerciseConfigurator().configure(for: muscleGroup,
                                                                                   trainingEntityTarget: trainingEntityTarge)
        rootViewController.navigationController?.pushViewController(selesctExerciseViewController, animated: true)
    }
}
