import UIKit

protocol ChoosenPaternRouterProtocol {
    func hideTrainingPaternsFlow()
    func popViewController()
    func showAddExerciseFlow(for trainingEntityTarget: TrainingEntityTarget)
}

final class ChoosenPaternRouter: Router {
    
    // MARK: - Private properties
    private let rootViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - TrainingPaternsRouterProtocol
extension ChoosenPaternRouter: ChoosenPaternRouterProtocol {
    
    func showAddExerciseFlow(for trainingEntityTarget: TrainingEntityTarget) {
        let selectMuscleGroupViewController = MuscleGroupsViewControllerConfigurator().configure(for: trainingEntityTarget)
        let addExerciseNavigationController = UINavigationController(rootViewController: selectMuscleGroupViewController)
        addExerciseNavigationController.modalPresentationStyle = .fullScreen
        topViewController?.present(addExerciseNavigationController, animated: true, completion: nil)
    }
    
    func hideTrainingPaternsFlow() {
        rootViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func popViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
}
