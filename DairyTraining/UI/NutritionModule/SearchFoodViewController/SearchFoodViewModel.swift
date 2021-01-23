import Foundation

protocol SearchFoodViewModelProtocol: MealDetailAlertDelegate {
    var foodList: [Food] { get }
    func requestFood(for text: String)
    func activatePaginationRequest()
    func cancelButtonPressed()
}

protocol SearchFoodViewModellInput: AnyObject {
    func foodListWasUpdated(to foodList: [Food])
    func foodListWasUpdatedAfterPagination(to foodList: [Food])
    func updateError(with message: String)
    func mealWasAdedToDaily(with description: String)
}

final class SearchFoodViewModel {
    
    // MARK: - Module properties
    weak var view: SearchFoodView?
    
    // MARK: - Private Properties
    private var model: SearchFoodModelProtocol
    private var searchingText: String?
    private var _foodList: [Food] = []
    
    // MARK: - Initialization
    init(model: SearchFoodModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionViewModelProtocol
extension SearchFoodViewModel: SearchFoodViewModelProtocol {
    
    func foodDetailAlert(mealDetailAlert: MealDetailAlert, mealWasAdded meal: MealModel) {
        model.addMealToDaily(meal: meal)
    }
    
    func cancelButtonPressed() {
        //MainCoordinator.shared.dismiss()
    }
    
    func activatePaginationRequest() {
        guard let searchingText = self.searchingText else { return }
        model.paginationRequest(for: searchingText)
    }
    
    var foodList: [Food] {
        return _foodList
    }
    
    func requestFood(for text: String) {
        searchingText = text
        model.requestFood(for: text)
    }
}

// MARK: - NutritionViewModelInput
extension SearchFoodViewModel: SearchFoodViewModellInput {
    
    func mealWasAdedToDaily(with description: String) {
        view?.showInfoAlert(with: "Meal aded", and: description)
    }

    func foodListWasUpdatedAfterPagination(to foodList: [Food]) {
        self._foodList += foodList
        view?.loadMoreItems()
    }
    
    func updateError(with message: String) {
        view?.showErrorLabel(with: message)
    }
    
    func foodListWasUpdated(to foodList: [Food]) {
        self._foodList = foodList
        view?.reloadTable()
    }
}
