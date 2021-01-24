import UIKit

protocol ReadyWotkoutRouterProtocol {
    func popViewController()
    func hideReadyTrainingFlow()
    
    func showInfoAlert(with message: String)
}

final class ReadyWotkoutRouter: Router {
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    private let rootViewController: UIViewController
}

extension ReadyWotkoutRouter: ReadyWotkoutRouterProtocol {
    
    func showInfoAlert(with message: String) {
        showInfoAlert(title: nil, message: message, alertType: .alert, completion: { [weak self] in
            self?.hideReadyTrainingFlow()
        })
    }
    
    func popViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    func hideReadyTrainingFlow() {
        rootViewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
