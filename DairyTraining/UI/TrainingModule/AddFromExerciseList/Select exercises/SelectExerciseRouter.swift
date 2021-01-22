import UIKit

protocol SelectExerciseRouterProtocol {
    func hideAddingExerciseFlow()
}

final class SelectExerciseRouter: Router {
   
    // MARK: - Private properties
    private let rootViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - SelectExerciseRouterProtocol
extension SelectExerciseRouter: SelectExerciseRouterProtocol {
    
    func hideAddingExerciseFlow() {
        rootViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
