import UIKit

protocol NutritionSettingRouterProtocol {
    func popViewController()
}

final class NutritionSettingRouter: Router {

    private let rootViewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension NutritionSettingRouter: NutritionSettingRouterProtocol {
    
    func popViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
}
