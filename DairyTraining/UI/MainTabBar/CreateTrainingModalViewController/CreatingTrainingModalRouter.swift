import UIKit

protocol CreatingTrainingModelRouterProtocol {
    func showScreen(for creatingWotkoutOption: CreatingTrainingModalModel.Option)
}

final class CreatingTrainingModelRouter: Router {
    
    private let rootViewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension CreatingTrainingModelRouter: CreatingTrainingModelRouterProtocol {
    
    func showScreen(for creatingWotkoutOption: CreatingTrainingModalModel.Option) {
        rootViewController.dismiss(animated: true, completion: { [weak self] in
            switch creatingWotkoutOption {
            case .fromExerciseList:
                self?.showExerciseFlow()
                
            case .fromTrainingPatern:
                self?.showWorkoutsPaternFlow()
                
            case .fromSpecialTraining:
                self?.showReadyWorkoutsFlow()
            }
        })
       
    }
}
