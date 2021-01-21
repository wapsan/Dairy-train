import UIKit

protocol MainNutritionRouterProtocol {
    func showSearchFoodScreen()
    func showNutritionSettingScreen()
}

final class MainNutritionRouter: Router {
    
    private let rootViewController: UIViewController

    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }

}

extension MainNutritionRouter: MainNutritionRouterProtocol {
    
    func showNutritionSettingScreen() {
        let nutritionSettingViewController = NutritionSettingConfigurator().configure()
        rootViewController.navigationController?.pushViewController(nutritionSettingViewController, animated: true)
    }

    func showSearchFoodScreen() {
        let searchFoodScreen = SearchFoodConfigurator().configure()
        rootViewController.navigationController?.pushViewController(searchFoodScreen, animated: true)
    }
}
