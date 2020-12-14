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
            topViewController?.present(searchFoodViewController, animated: true, completion: nil)
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
}
