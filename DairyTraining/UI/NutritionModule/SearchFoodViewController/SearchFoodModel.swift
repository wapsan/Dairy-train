import Foundation

protocol SearchFoodModelProtocol {
    func requestFood(for text: String)
    func paginationRequest(for text: String)
    func addMealToDaily(meal: MealModel)
}

final class SearchFoodModel {
    
    // MARK: - Module Properties
    weak var output: SearchFoodViewModellInput?
    private let foodSearchService = USDAManager()
    private var requestPageNumber = 1
}

// MARK: - NutritionModelProtocol
extension SearchFoodModel: SearchFoodModelProtocol {
    
    func addMealToDaily(meal: MealModel) {
        NutritionDataManager.shared.addMeal(meal)
        NotificationCenter.default.post(name: .mealWasAddedToDaily, object: nil)
    }
    
    func paginationRequest(for text: String) {
        requestPageNumber += 1
        foodSearchService.searchFoodWithName(text, pageNumber: requestPageNumber) { [weak self] (response) in
            switch response {
            case .success(let responseModel):
                self?.output?.foodListWasUpdatedAfterPagination(to: responseModel.foods)
            case .failure(let error):
                self?.output?.updateError(with: error.message)
            }
        }
    }
    
    func requestFood(for text: String) {
        foodSearchService.searchFoodWithName(text) { [weak self] (response) in
            switch response {
            case .success(let responseModel):
                self?.output?.foodListWasUpdated(to: responseModel.foods)
            case .failure(let error):
                self?.output?.updateError(with: error.message)
            }
        }
    }
}
