import Foundation

protocol NutritionViewModelProtocol {
 
}

protocol NutritionViewModelInput: AnyObject {
}

final class NutritionViewModel {
    
    // MARK: - Module properties
    weak var view: MainNutritionView?
    
    // MARK: - Private Properties
    private let model: NutritionModelProtocol
    
    // MARK: - Initialization
    init(model: NutritionModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionViewModelProtocol
extension NutritionViewModel: NutritionViewModelProtocol {

}

// MARK: - NutritionViewModelInput
extension NutritionViewModel: NutritionViewModelInput {
    

}
