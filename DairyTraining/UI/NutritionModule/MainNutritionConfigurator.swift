import UIKit

final class MainNutritionConfigurator {
    
    static func configureMainNutritionModule() -> UINavigationController {
        let nutritionModel = NutritionModel()
        let nutritionViewModel = NutritionViewModel(model: nutritionModel)
        let nutritionViewController = MainNutritionViewController(viewModel: nutritionViewModel)
        let nutritionRouter = MainNutritionRouter(nutritionViewController)
        nutritionModel.output = nutritionViewModel
        nutritionViewModel.view = nutritionViewController
        nutritionViewModel.router = nutritionRouter
        let navigationController = UINavigationController(rootViewController: nutritionViewController)
        navigationController.tabBarItem = MainTabBarModel.Item.nutrition.item
        nutritionViewController.navigationItem.title = MainTabBarModel.Item.nutrition.title
        return navigationController
    }
}
