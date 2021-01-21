import UIKit

final class SearchFoodConfigurator {
    
    func configure() -> SearchFoodViewController {
        let searchFoodModel = SearchFoodModel()
        let searchFoodViewModel = SearchFoodViewModel(model: searchFoodModel)
        let searchFoodViewController = SearchFoodViewController(viewModel: searchFoodViewModel)
        searchFoodModel.output = searchFoodViewModel
        searchFoodViewModel.view = searchFoodViewController
        return searchFoodViewController
    }
}
