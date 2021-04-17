import UIKit

protocol TrainingPaternsRouterProtocol {
    func closeTrainingPaternsFlow()
    func showTrainingPaternScreen(for trainingPatern: WorkoutTemplateMO)
}

final class TrainingPaternsRouter: Router {
    
    // MARK: - Private properties
    private let rootViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - TrainingPaternsRouterProtocol
extension TrainingPaternsRouter: TrainingPaternsRouterProtocol {
    
    func closeTrainingPaternsFlow() {
        rootViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showTrainingPaternScreen(for trainingPatern: WorkoutTemplateMO) {
        let chooseTrainingPaternViewController = ChoosenPaternConfigurator().configure(for: trainingPatern)
        rootViewController.navigationController?.pushViewController(chooseTrainingPaternViewController, animated: true)
    }
}
