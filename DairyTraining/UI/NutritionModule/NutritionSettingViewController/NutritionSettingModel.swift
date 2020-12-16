import Foundation
 
protocol NutritionettingModelProtocol {
    func getSelectednutritionMode()
    func markNutritionModeAsSelected(_ mode: NutritionMode)
    func saveMode()
}

final class NutritionSettingModel {
    
    weak var output: NutritionSettingViewModelInput?
    
    // MARK: - Private methods
    private var nutritionSettingManager = NutritionSettingManager.shared
    private var _selectedMode = NutritionMode.balanceWeight {
        didSet {
            output?.updateCurrentNutritionMode(to: self._selectedMode)
        }
    }
    
}

extension NutritionSettingModel: NutritionettingModelProtocol {
    
    func saveMode() {
        nutritionSettingManager.setNutritionMode(to: _selectedMode)
    }
    
    func markNutritionModeAsSelected(_ mode: NutritionMode) {
        _selectedMode = mode
    }
    
    func getSelectednutritionMode() {
        let selectedMode = nutritionSettingManager.getCurrentNutritionMode()
        _selectedMode = selectedMode
    }
}
