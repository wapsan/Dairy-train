//
//  NutritionModuleCoordinator.swift
//  Dairy Training
//
//  Created by cogniteq on 14.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//
import UIKit

final class NutritionModuleCoordinator: Coordinator {

    //MARK: - Constants
    private struct Constants {
    }
    
    // MARK: - Types
    enum Target: CoordinatorTarget {
        case searchFood
        case nutritionSetting
    }
    
    // MARK: - Properties
    var window: UIWindow?
    private var navigationController: UINavigationController?
    
    // MARK: - Init

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        case .searchFood:
            let searchFoodViewController = configureSearchFoodViewController()
            navigationController?.pushViewController(searchFoodViewController, animated: true)
        case .nutritionSetting:
            let nutritionSettingViewController = congigureNutritionSettingViewController()
            navigationController?.pushViewController(nutritionSettingViewController, animated: true)
        }
        return true
    }

    // MARK: - Configuration methods
    private func configureSearchFoodViewController() -> SearchFoodViewController {
        let searchFoodModel = SearchFoodModel()
        let searchFoodViewModel = SearchFoodViewModel(model: searchFoodModel)
        let searchFoodViewController = SearchFoodViewController(viewModel: searchFoodViewModel)
        searchFoodModel.output = searchFoodViewModel
        searchFoodViewModel.view = searchFoodViewController
        return searchFoodViewController 
    }
    
    private func congigureNutritionSettingViewController() -> NutritionSettingViewController {
        let nutritionSettingModel = NutritionSettingModel()
        let nutritionSettingViewModel = NutritionSettingViewModel(model: nutritionSettingModel)
        let nutritionSettingViewController = NutritionSettingViewController(viewModel: nutritionSettingViewModel)
        nutritionSettingViewModel.view = nutritionSettingViewController
        nutritionSettingModel.output = nutritionSettingViewModel
        return nutritionSettingViewController
    }
}
