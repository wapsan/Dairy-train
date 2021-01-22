import UIKit

protocol CreatingTrainingModalRouterDelegate: AnyObject {
    func showExerciseFlow()
    func showTrainingPaternFlow()
    func showReadyWorkoutFlow()
}

protocol CreatingTrainingModelRouterProtocol {
    func showScreen(for creatingWotkoutOption: CreatingTrainingModalModel.Option)
}

final class CreatingTrainingModelRouter: Router {
    
    private let rootViewController: UIViewController
    weak var delegate: CreatingTrainingModalRouterDelegate?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension CreatingTrainingModelRouter: CreatingTrainingModelRouterProtocol {
    
    func showScreen(for creatingWotkoutOption: CreatingTrainingModalModel.Option) {
        switch creatingWotkoutOption {
        case .fromExerciseList:
            delegate?.showExerciseFlow()
        case .fromTrainingPatern:
            delegate?.showTrainingPaternFlow()
        case .fromSpecialTraining:
            delegate?.showReadyWorkoutFlow()
        }
    }
}
