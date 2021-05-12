import UIKit

protocol AddPopUpRouterProtocol {
    func showScreen(for creatingWotkoutOption: AddPopUpInteractor.Option)
}

final class AddPopUpRouter: Router {
    
    private weak var rootViewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension AddPopUpRouter: AddPopUpRouterProtocol {
    
    func showScreen(for creatingWotkoutOption: AddPopUpInteractor.Option) {
        rootViewController?.dismiss(animated: true, completion: { [weak self] in
            switch creatingWotkoutOption {
            case .fromExerciseList:
                self?.showExerciseFlow()
                
            case .fromTrainingPatern:
                self?.showWorkoutsPaternFlow()
                
            case .fromSpecialTraining:
                self?.showReadyWorkoutsFlow()
                
            case .searchFood:
                self?.showSearchFoodFlow()
                
            case .customFood:
                print("Add custom calories")
            }
        })
       
    }
}
