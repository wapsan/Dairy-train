
import UIKit

final class ChoosenPaternRouter: Router {
    
    //MARK: - Properties
    private var rootViewController: ChoosenPaternViewController?
    
    //MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? ChoosenPaternViewController
    }
    
    //MARK: - Interface
    func pushMuscleGroupViewController(with currentPatern: TrainingPaternManagedObject) {
        let muscleGroupViewControllr = configureMuscleGroupViewController(with: currentPatern)
        let nav = UINavigationController(rootViewController: muscleGroupViewControllr)
        nav.modalPresentationStyle = .fullScreen
        rootViewController?.present(nav, animated: true, completion: nil)
//        rootViewController?.navigationController?.pushViewController(muscleGroupViewControllr,
//                                                                     animated: true)
    }
}
 
private extension ChoosenPaternRouter {
    
    func configureMuscleGroupViewController(with trainingPatern: TrainingPaternManagedObject) -> MuscleGroupsViewController {
        let muscleGroupViewController = MuscleGroupsViewController(trainingEntityTarget: .trainingPatern(trainingPatern: trainingPatern))
        let muscleGroupViewModel = MuscleGroupsViewModel()
        let muscleGroupRouter = MuscleGroupsRouter(muscleGroupViewController)
        muscleGroupViewController.router = muscleGroupRouter
        muscleGroupViewController.viewModel = muscleGroupViewModel
        muscleGroupViewModel.viewPresenter = muscleGroupViewController
        return muscleGroupViewController
    }
}
