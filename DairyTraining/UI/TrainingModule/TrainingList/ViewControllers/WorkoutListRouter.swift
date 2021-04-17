import UIKit

protocol WorkoutListRouterProtocol {
    func showChoosenWorkoutScreen(for workout: WorkoutMO)
}

final class WorkoutListRouter: Router {
    
    // MARK: - Private properties
    private weak var rootViewController: UIViewController?
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - WorkoutListRouterProtocol
extension WorkoutListRouter: WorkoutListRouterProtocol {
    
    func showChoosenWorkoutScreen(for workout: WorkoutMO) {
        let choosenWorkoutViewController = WorkoutConfigurator.configure(for: workout)
        rootViewController?.navigationController?.pushViewController(choosenWorkoutViewController, animated: true)
    }
}
