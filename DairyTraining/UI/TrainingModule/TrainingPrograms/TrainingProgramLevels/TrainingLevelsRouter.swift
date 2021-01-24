import UIKit

protocol TrainingLevelsRouterProtocol {
    func showWorkoutsScreen(for trainingLevel: TrainingLevelsModel.Level)
    func hideReadyWorkoutsFlow()
}

final class TrainingLevelsRouter: Router {
    
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    private let rootViewController: UIViewController
    
    
    
}


extension TrainingLevelsRouter: TrainingLevelsRouterProtocol {
    
    func showWorkoutsScreen(for trainingLevel: TrainingLevelsModel.Level) {
        let trainingProgrammViewController = TrainingProgramsConfigurator.configure(for: trainingLevel)
        rootViewController.navigationController?.pushViewController(trainingProgrammViewController,
                                                                    animated: true)
    }
    
    func hideReadyWorkoutsFlow() {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}
