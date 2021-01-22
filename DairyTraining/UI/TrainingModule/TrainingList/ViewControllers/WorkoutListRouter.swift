import UIKit

protocol WorkoutListRouterProtocol {
    func showChoosenWorkoutScreen(for workout: TrainingManagedObject)
}

final class WorkoutListRouter: Router {
    
    // MARK: - Private properties
    private let rootViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - WorkoutListRouterProtocol
extension WorkoutListRouter: WorkoutListRouterProtocol {
    
    func showChoosenWorkoutScreen(for workout: TrainingManagedObject) {
        let choosenWorkoutViewController = WorkoutConfigurator.configure(for: workout)
        rootViewController.navigationController?.pushViewController(choosenWorkoutViewController, animated: true)
    }
}
