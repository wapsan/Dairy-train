import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
    var nutritionMode: NutritionMode { get }
    func loadData()
}

final class NutritionModel {
    
    // MARK: - Module Properties
    weak var output: NutritionViewModelInput?
    private var _recomendation: NutritionRecomendation? {
        didSet {
            output?.recomendationWasChanged(to: _recomendation)
        }
    }
    private var _nutritionData: NutritionDataMO?
    private var calculator: CaloriesRecomendationCalculator?
    private var userInfo: MainInfoManagedObject?
    init(userInfo: MainInfoManagedObject?) {
//        _nutritionData = NutritionDataManager.shared.todayNutritionData
//        if let a = userInfo {
//            calculator = CaloriesRecomendationCalculator(userInfo: a)
//            if UserDataManager.shared.getNutritionMode() == .custom {
//                _recomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
//            } else {
//                _recomendation = calculator?.getRecomendation(for: UserDataManager.shared.getNutritionMode())
//            }
//          //  output?.updateMealPlaneMode(to: UserDataManager.shared.getNutritionMode())
//        }
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(nutritionModeChanged),
                                               name: .nutritionmodeWasChanged,
                                               object: nil)
        
    }
    
    @objc private func nutritionModeChanged() {
        if UserDataManager.shared.getNutritionMode() == .custom {
            _recomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
        } else {
            _recomendation = calculator?.getRecomendation(for: UserDataManager.shared.getNutritionMode())
        }
        output?.updateMealPlaneMode(to: UserDataManager.shared.getNutritionMode())
    }
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    func loadData() {
        _nutritionData = NutritionDataManager.shared.todayNutritionData
        userInfo = UserDataManager.shared.readUserMainInfo()
        _nutritionData = NutritionDataManager.shared.todayNutritionData
        if let a = userInfo {
            calculator = CaloriesRecomendationCalculator(userInfo: a)
            if UserDataManager.shared.getNutritionMode() == .custom {
                _recomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
            } else {
                _recomendation = calculator?.getRecomendation(for: UserDataManager.shared.getNutritionMode())
            }
          //  output?.updateMealPlaneMode(to: UserDataManager.shared.getNutritionMode())
        }
    }
    
    
    var nutritionData: NutritionDataMO {
        NutritionDataManager.shared.todayNutritionData//_nutritionData!
    }
    
    var nutritionMode: NutritionMode {
        UserDataManager.shared.getNutritionMode()
    }
    var recomendation: NutritionRecomendation? {
        _recomendation
    }
}
