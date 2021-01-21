import UIKit

final class MainNutritionConfigurator {
    
    func configureMainNutritionModule() -> UINavigationController {
        let nutritionModel = NutritionModel()
        let nutritionViewModel = NutritionViewModel(model: nutritionModel)
        let nutritionViewController = MainNutritionViewController(viewModel: nutritionViewModel)
        let nutritionRouter = MainNutritionRouter(nutritionViewController)
        nutritionModel.output = nutritionViewModel
        nutritionViewModel.view = nutritionViewController
        nutritionViewModel.router = nutritionRouter
        let navigationController = UINavigationController(rootViewController: nutritionViewController)
        navigationController.tabBarItem = DTTabBarItems.nutrition.item
        nutritionViewController.navigationItem.title = DTTabBarItems.nutrition.title
        return navigationController
    }
}
