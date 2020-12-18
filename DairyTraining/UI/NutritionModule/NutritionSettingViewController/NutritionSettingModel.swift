import Foundation
 
protocol NutritionettingModelProtocol {
    
    var selectedMode: NutritionMode { get }
    
    func getSelectednutritionMode()
    func changeSelectedNutritionMode(to mode: NutritionMode)
    func saveNewNutritionMode()
    
    func saveCustomCalories(calories: Int)
}

final class NutritionSettingModel {
    
    weak var output: NutritionSettingViewModelInput?
    
    // MARK: - Private methods
    private var caloriesCalculator = CaloriesRecomendationCalculator(userInfo: UserDataManager.shared.readUserMainInfo())
    private var _selectedMode = UserDataManager.shared.getNutritionMode() {
        didSet {
            guard var caloriesCalculator = self.caloriesCalculator else {
                output?.userInfoNotSet()
                return
            }
            if _selectedMode == .custom {
                let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
                output?.updateNutritionRecomandation(to: nutritionRecomendation)
            } else {
                output?.updateNutritionRecomandation(to: caloriesCalculator.getRecomendation(for: _selectedMode))
            }
        }
    }
    
}

extension NutritionSettingModel: NutritionettingModelProtocol {
    
    func saveCustomCalories(calories: Int) {
        NutritionDataManager.shared.updateCustomCalories(to: calories)
        output?.customCaloriesWasSet(to: calories)
    }
    
    func saveNewNutritionMode() {
        UserDataManager.shared.updateNutritionMode(to: _selectedMode)
        NotificationCenter.default.post(name: .nutritionmodeWasChanged, object: nil)
    }
    
    var selectedMode: NutritionMode {
        _selectedMode
    }
    
    func changeSelectedNutritionMode(to mode: NutritionMode) {
        _selectedMode = mode
        output?.changeNutritionSelection(to: _selectedMode)
    }

    func getSelectednutritionMode() {
        let selectedMode = UserDataManager.shared.getNutritionMode()
        _selectedMode = selectedMode
        output?.loadCurrentNutritionMode(to: self._selectedMode)
    }
}
