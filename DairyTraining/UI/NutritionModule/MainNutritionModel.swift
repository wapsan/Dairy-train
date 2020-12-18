import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
}

final class NutritionModel {
    
    // MARK: - Module Properties
    weak var output: NutritionViewModelInput?
    private var _recomendation: NutritionRecomendation? {
        didSet {
            output?.recomendationWasChanged(to: _recomendation)
        }
    }
    private var _nutritionData: NutritionDataMO
    private var calculator: CaloriesRecomendationCalculator?
    
    init(userInfo: MainInfoManagedObject?) {
        _nutritionData = NutritionDataManager.shared.todayNutritionData
        if let a = userInfo {
            calculator = CaloriesRecomendationCalculator(userInfo: a)
            _recomendation = calculator?.getRecomendation(for: UserDataManager.shared.getNutritionMode())
           // output?.updateRecomendations(recomendation: calore.getRecomendation(for: .balanceWeight))
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(nuutritionModeChanged),
                                               name: .nutritionmodeWasChanged,
                                               object: nil)
    }
    
    @objc private func nuutritionModeChanged() {
        _recomendation = calculator?.getRecomendation(for: UserDataManager.shared.getNutritionMode())
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
