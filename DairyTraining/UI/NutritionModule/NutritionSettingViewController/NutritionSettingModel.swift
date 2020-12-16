import Foundation
 
protocol NutritionettingModelProtocol {
    func getSelectednutritionMode()
    func markNutritionModeAsSelected(_ mode: NutritionMode)
    func saveMode()
    func changeSelectedNutritionMode(to mode: NutritionMode)
}

final class NutritionSettingModel {
    
    weak var output: NutritionSettingViewModelInput?
    
    // MARK: - Private methods
    private var nutritionSettingManager = NutritionSettingManager.shared
    private var _selectedMode = NutritionMode.balanceWeight {
        didSet {
            
        }
    }
    
}

extension NutritionSettingModel: NutritionettingModelProtocol {
    
    func changeSelectedNutritionMode(to mode: NutritionMode) {
        _selectedMode = mode
        output?.changeNutritionSelection(to: _selectedMode)
    }
    
    func saveMode() {
        nutritionSettingManager.setNutritionMode(to: _selectedMode)
    }
    
    func markNutritionModeAsSelected(_ mode: NutritionMode) {
       // _selectedMode = mode
    }
    
    func getSelectednutritionMode() {
        let selectedMode = nutritionSettingManager.getCurrentNutritionMode()
        _selectedMode = selectedMode
        output?.loadCurrentNutritionMode(to: self._selectedMode)
    }
}
