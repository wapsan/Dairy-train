import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
}

final class NutritionModel {
    
    // MARK: - Module Properties
    weak var output: NutritionViewModelInput?
    private var _recomendation: NutritionRecomendation?
    private var _nutritionData: NutritionDataMO
    
    init(userInfo: MainInfoManagedObject?) {
        _nutritionData = NutritionDataManager.shared.todayNutritionData
        if let a = userInfo {
            var calore = CaloriesRecomendationCalculator(userInfo: a)
            _recomendation = calore.getRecomendation(for: .balanceWeight)
           // output?.updateRecomendations(recomendation: calore.getRecomendation(for: .balanceWeight))
        }
    }
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    
    var nutritionData: NutritionDataMO {
        _nutritionData
    }
    
    var recomendation: NutritionRecomendation? {
        _recomendation
    }
}
