import Foundation
 
protocol NutritionettingModelProtocol {
    
    var selectedMode: NutritionMode { get }
    
    var nutritionMode: NutritionMode { get }
    
    func getSelectednutritionMode()
    func changeSelectedNutritionMode(to mode: NutritionMode)
    func saveNewNutritionMode()
    
    func saveCustomCalories(calories: Int)
    
    func saveCustomnutritionPercentageFor(proteins: Int, carbohydrates: Int, fats: Int)
    func getNutritionInfoForCustomMode()
}

final class NutritionSettingModel {
    
    weak var output: NutritionSettingViewModelInput?
    
    // MARK: - Private methods
    private var caloriesCalculator = CaloriesRecomendationCalculator(userInfo: UserDataManager.shared.readUserMainInfo())
    private var _selectedMode = UserDataManager.shared.getNutritionMode() {
        didSet {
            if _selectedMode == .custom {
                updateCustomNutritionRecomendation()
            } else {
                updateNutritionRecomendation()
            }
        }
    }
    
    private func updateCustomNutritionRecomendation() {
        let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
        output?.updateNutritionRecomandation(to: nutritionRecomendation)
    }
    
    private func updateNutritionRecomendation() {
        guard var caloriesCalculator = self.caloriesCalculator else { return }
        output?.updateNutritionRecomandation(to: caloriesCalculator.getRecomendation(for: _selectedMode))
    }
}

extension NutritionSettingModel: NutritionettingModelProtocol {
    
    var nutritionMode: NutritionMode {
        UserDataManager.shared.getNutritionMode()
    }
    
    func getNutritionInfoForCustomMode() {
        let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
        output?.updateCutomNutritionInfo(for: nutritionRecomendation)
    }
    
    func saveCustomnutritionPercentageFor(proteins: Int, carbohydrates: Int, fats: Int) {
        NutritionDataManager.shared.updateCustomPercentageFor(proteinsPercentage: Float(proteins),
                                                              carbohydratesPercentage: Float(carbohydrates),
                                                              fatsPercentage: Float(fats))
        let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
        output?.updateNutritionRecomandation(to: nutritionRecomendation)
    }
    
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
