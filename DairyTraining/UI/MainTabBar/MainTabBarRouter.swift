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
        let optionModalViewController = CreatingTrainingModalConfigurator.configure()
        optionModalViewController.modalPresentationStyle = .custom
        optionModalViewController.transitioningDelegate = self
        rootViewController.present(optionModalViewController, animated: true, completion: nil)
    }
}

extension MainTabBarRouter: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CreatinTrainingPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    
}
