import UIKit

final class NutritionSettingConfigurator {
    
    func configure() -> NutritionSettingViewController {
        let nutritionSettingModel = NutritionSettingModel()
        let nutritionSettingViewModel = NutritionSettingViewModel(model: nutritionSettingModel)
        let nutritionSettingViewController = NutritionSettingViewController(viewModel: nutritionSettingViewModel)
        nutritionSettingViewModel.view = nutritionSettingViewController
        nutritionSettingModel.output = nutritionSettingViewModel
        return nutritionSettingViewController
    }
}
