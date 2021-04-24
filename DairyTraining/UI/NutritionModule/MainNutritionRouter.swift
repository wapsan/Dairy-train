import UIKit

protocol MainNutritionRouterProtocol {
    func showSearchFoodScreen()
    func showNutritionSettingScreen()
}

final class MainNutritionRouter: Router {
    
    private weak var rootViewController: UIViewController?

    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

extension MainNutritionRouter: MainNutritionRouterProtocol {
    
    func showNutritionSettingScreen() {
        let nutritionSettingViewController = NutritionSettingConfigurator().configure()
        rootViewController?.navigationController?.pushViewController(nutritionSettingViewController, animated: true)
    }

    func showSearchFoodScreen() {
        showSearchFoodFlow()
    }
}
