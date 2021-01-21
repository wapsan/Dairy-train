import UIKit

protocol NutritionSettingRouterProtocol {
    
}

final class NutritionSettingRouter: Router {
    
    private let rootViewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension NutritionSettingRouter: NutritionSettingRouterProtocol {
    
}
