import Foundation
 
protocol NutritionettingModelProtocol {
    var selectedMode: NutritionMode { get }
    
    func getSelectednutritionMode()
    func markNutritionModeAsSelected(_ mode: NutritionMode)
    func saveMode()
    func changeSelectedNutritionMode(to mode: NutritionMode)
    func saveNewNutritionMode()
}

final class NutritionSettingModel {
    
    weak var output: NutritionSettingViewModelInput?
    
    // MARK: - Private methods
    private var caloriesCalculator = CaloriesRecomendationCalculator(userInfo: UserDataManager.shared.readUserMainInfo())
    private var nutritionSettingManager = NutritionSettingManager.shared
    private var _selectedMode = UserDataManager.shared.getNutritionMode() {
        didSet {
            guard var caloriesCalculator = self.caloriesCalculator else {
                output?.userInfoNotSet()
                return
            }
            output?.updateNutritionRecomandation(to: caloriesCalculator.getRecomendation(for: _selectedMode))
        }
    }
    
    init() {
        
    }
    
}

extension NutritionSettingModel: NutritionettingModelProtocol {
    
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
    
    func saveMode() {
        nutritionSettingManager.setNutritionMode(to: _selectedMode)
    }
    
    func markNutritionModeAsSelected(_ mode: NutritionMode) {
       // _selectedMode = mode
    }
    
    func getSelectednutritionMode() {
        let selectedMode = UserDataManager.shared.getNutritionMode()//nutritionSettingManager.getCurrentNutritionMode()
        _selectedMode = selectedMode
        output?.loadCurrentNutritionMode(to: self._selectedMode)
    }
}
