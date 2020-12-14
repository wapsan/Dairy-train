import Foundation

protocol NutritionViewModelProtocol {
    var foodList: [Food] { get }
    func requestFood(for text: String)
}

protocol NutritionViewModelInput: AnyObject {
    func foodListWasUpdated(to foodList: [Food])
}

final class NutritionViewModel {
    
    // MARK: - Module properties
    weak var view: MainNutritionView?
    
    // MARK: - Private Properties
    private var model: NutritionModelProtocol
    private var _foodList: [Food] = [] {
        didSet {
            view?.updateFoodList()
        }
    }
    
    // MARK: - Initialization
    init(model: NutritionModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionViewModelProtocol
extension NutritionViewModel: NutritionViewModelProtocol {
    
    var foodList: [Food] {
        return _foodList
    }
    
    func requestFood(for text: String) {
        model.requestFood(for: text)
    }
}

// MARK: - NutritionViewModelInput
extension NutritionViewModel: NutritionViewModelInput {
    
    func foodListWasUpdated(to foodList: [Food]) {
        self._foodList = foodList
    }
}
