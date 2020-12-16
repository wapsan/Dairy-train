import Foundation

final class NutritionSettingManager {
    
    static let shared = NutritionSettingManager()
    
    private struct Key {
        static let nutritionMode = "nutrition_Mode_Key"
    }
    
    private struct NutritionmodeRawValue {
        static let weightLose = ""
        static let balanceWeight = ""
        static let loseWeight = ""
        static let custom = ""
    }
    
    private let defaults = UserDefaults.standard
    
    func getCurrentNutritionMode() -> NutritionMode {
        guard let currnetModeRawValue = defaults.value(forKey: Key.nutritionMode) as? String,
              let currentMode = NutritionMode(rawValue: currnetModeRawValue) else { return .balanceWeight }
        return currentMode
    }
    
    func setNutritionMode(to nutritionMode: NutritionMode) {
        defaults.setValue(nutritionMode.rawValue, forKey: Key.nutritionMode)
    }
}
 
