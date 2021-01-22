import UIKit

protocol MainTabBarRouterProtocol {
    func showCreateTrainingoptionsPopUpScreen()
}


final class MainTabBarRouter: NSObject, Router {
  
    
    private let rootViewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
        super.init()
    }
}

extension MainTabBarRouter: MainTabBarRouterProtocol {
    
    func showCreateTrainingoptionsPopUpScreen() {
        let a = CreatingTrainingModalConfigurator.configure(with: self)
        a.modalPresentationStyle = .custom
        a.transitioningDelegate = self
        rootViewController.present(a, animated: true, completion: nil)
    }
}

extension MainTabBarRouter: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CreatinTrainingPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    
}

 
extension MainTabBarRouter: CreatingTrainingModalRouterDelegate {
    
    func showExerciseFlow() {
        
    }
    
    func showTrainingPaternFlow() {
        
    }
    
    func showReadyWorkoutFlow() {
        
    }
}
