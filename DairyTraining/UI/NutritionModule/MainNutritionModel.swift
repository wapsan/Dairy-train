import Foundation

protocol NutritionModelProtocol {
    func requestFood(for text: String)
}

final class NutritionModel {
    
    // MARK: - Module Properties
    weak var output: NutritionViewModelInput?
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    
    func requestFood(for text: String) {
        NetworkManager.shared.requestNutritionInfo(for: text) { (response) in
            switch response {
            case .success(let responseModel):
                self.output?.foodListWasUpdated(to: responseModel.hints.map({ $0.food }))
            case .failure(_):
                print("Here")
            }
        }
    }
}
