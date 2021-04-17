import Foundation

protocol SearchFoodModelProtocol {
    func requestFood(for text: String)
    func paginationRequest(for text: String)
    func addMealToDaily(meal: MealResponseModel)
}

final class SearchFoodModel {
    
    // MARK: - Module Properties
    weak var output: SearchFoodViewModellInput?

    //MARK: - Private
    private var requestPageNumber = 1
    private let foodSearchService: SearchFoodAPI
    private let persistenceService: PersistenceServiceProtocol
    
    //MARK: - Initialization
    init(persistenceService: PersistenceServiceProtocol = PersistenceService(),
         foodSearchService: SearchFoodAPI = SearchFoodAPI()) {
        self.foodSearchService = foodSearchService
        self.persistenceService = persistenceService
    }
    
}

// MARK: - NutritionModelProtocol
extension SearchFoodModel: SearchFoodModelProtocol {
    
    func addMealToDaily(meal: MealResponseModel) {
        persistenceService.nutrition.addMeal(meal: meal)
        NotificationCenter.default.post(name: .mealWasAddedToDaily, object: nil)
        output?.mealWasAdedToDaily(with: "\(meal.mealName) with weight of \(meal.weight) gramms.")
    }
    
    func paginationRequest(for text: String) {
        requestPageNumber += 1
        foodSearchService.searchFoodWithName(text, pageNumber: requestPageNumber) { [weak self] (response) in
            switch response {
            case .success(let responseModel):
                guard !responseModel.foods.isEmpty else  {
                    self?.output?.updateError(with: "Sorry we can not find whats are you looking for.")
                    return
                }
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
