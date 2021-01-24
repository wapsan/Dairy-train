import UIKit

final class SearchFoodConfigurator {
    
    func configure() -> SearchFoodViewController {
        let searchFoodModel = SearchFoodModel()
        let searchFoodViewModel = SearchFoodViewModel(model: searchFoodModel)
        let searchFoodViewController = SearchFoodViewController(viewModel: searchFoodViewModel)
        let searchFoodRouter = SearchFoodRouter(searchFoodViewController)
        searchFoodModel.output = searchFoodViewModel
        searchFoodViewModel.view = searchFoodViewController
        searchFoodViewModel.router = searchFoodRouter
        return searchFoodViewController
    }
}
