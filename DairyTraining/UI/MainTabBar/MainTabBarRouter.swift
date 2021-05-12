import UIKit

protocol MainTabBarRouterProtocol {
    func showCreateTrainingoptionsPopUpScreen()
}


final class MainTabBarRouter: NSObject, Router {
  
    
    private weak var rootViewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
        super.init()
    }
}

extension MainTabBarRouter: MainTabBarRouterProtocol {
    
    func showCreateTrainingoptionsPopUpScreen() {
        guard let selectedIndex = (rootViewController as? UITabBarController)?.selectedIndex else { return }
        let a: AddPopUpInteractor.AddingOptionType = selectedIndex == 1 ? .mealEntity : .trainingEntity
        let optionModalViewController = CreatingTrainingModalConfigurator.configure(for: a)
        optionModalViewController.modalPresentationStyle = .custom
        optionModalViewController.transitioningDelegate = self
        rootViewController?.present(optionModalViewController, animated: true, completion: nil)
    }
}

extension MainTabBarRouter: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        AddPopUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
