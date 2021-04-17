import Foundation
 
protocol NutritionSettingModelProtocol {
    
    var selectedMode: UserInfo.NutritionMode { get }
    var nutritionMode: UserInfo.NutritionMode { get }
    
    func getSelectednutritionMode()
    func changeSelectedNutritionMode(to mode: UserInfo.NutritionMode)
    func saveNewNutritionMode()
    
    func saveCustomCalories(calories: Int)
    
    func saveCustomnutritionPercentageFor(proteins: Int, carbohydrates: Int, fats: Int)
    func getNutritionInfoForCustomMode()
}

final class NutritionSettingModel {
    
    //MARK: - Internals properties
    weak var output: NutritionSettingViewModelInput?
    
    // MARK: - Private methods
    private var persistenceService: PersistenceServiceProtocol
    
    private lazy var caloriesCalculator = CaloriesRecomendationCalculator(userInfo: persistenceService.user.userInfo)
    private lazy var _selectedMode = persistenceService.user.userInfo.userNutritionMode {
        didSet {
            if _selectedMode == .custom {
                updateCustomNutritionRecomendation()
            } else {
                updateNutritionRecomendation()
            }
        }
    }
    
    //MARK: - Initialization
    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
        NotificationCenter.default.post(name: .nutritionmodeWasChanged, object: self)
    }
    
    //MARK: - Private
    private func updateCustomNutritionRecomendation() {
        let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: persistenceService.nutrition.customNutritionMode)
        output?.updateNutritionRecomandation(to: nutritionRecomendation)
    }
    
    private func updateNutritionRecomendation() {
        guard var caloriesCalculator = self.caloriesCalculator else { return }
        output?.updateNutritionRecomandation(to: caloriesCalculator.getRecomendation(for: _selectedMode))
    }
}

//MARK: - NutritionettingModelProtocol
extension NutritionSettingModel: NutritionSettingModelProtocol {
    
    var nutritionMode: UserInfo.NutritionMode {
        persistenceService.user.userInfo.userNutritionMode
    }
    
    func getNutritionInfoForCustomMode() {
        let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: persistenceService.nutrition.customNutritionMode)
        output?.updateCutomNutritionInfo(for: nutritionRecomendation)
    }
    
    func saveCustomnutritionPercentageFor(proteins: Int, carbohydrates: Int, fats: Int) {
        persistenceService.nutrition.updateCustomNutritionModePercentage(protein: proteins.float,
                                                                         carbohydrates: carbohydrates.float,
                                                                         fats: fats.float)
        let nutritionRecomendation = NutritionRecomendation(customNutritionRecomendation: persistenceService.nutrition.customNutritionMode)
        output?.updateNutritionRecomandation(to: nutritionRecomendation)
    }
    
    func saveCustomCalories(calories: Int) {
        persistenceService.nutrition.updateCustomNutritionMode(calories: calories)
        output?.customCaloriesWasSet(to: calories)
    }
    
    func saveNewNutritionMode() {
        persistenceService.user.updateUserInfo(.nutritionMode(nutritionMode: _selectedMode))
        NotificationCenter.default.post(name: .nutritionmodeWasChanged, object: nil)
    }
    
    var selectedMode: UserInfo.NutritionMode {
        _selectedMode
    }
    
    func changeSelectedNutritionMode(to mode: UserInfo.NutritionMode) {
        _selectedMode = mode
        output?.changeNutritionSelection(to: _selectedMode)
    }

    func getSelectednutritionMode() {
        _selectedMode = persistenceService.user.userInfo.userNutritionMode
        output?.loadCurrentNutritionMode(to: self._selectedMode)
    }
}
