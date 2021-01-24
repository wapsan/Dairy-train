import UIKit

protocol ReadyWotkoutRouterProtocol {
    func popViewController()
    func hideReadyTrainingFlow()
}

final class ReadyWotkoutRouter: Router {
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    private let rootViewController: UIViewController
    
    
}

extension ReadyWotkoutRouter: ReadyWotkoutRouterProtocol {
    
    func popViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    func hideReadyTrainingFlow() {
        rootViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
