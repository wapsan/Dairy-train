import Foundation

protocol NutritionSettingViewModelProtocol {
    
    var settingModel: [UserInfo.NutritionMode] { get }
    var selectedIndex: Int { get }
    
    func viewDidLoad()
    func selectRow(at index: Int)
    func saveButtonPressed()
    
    func saveCustomCalories(calories: String?)
    func makronutrientsPercentageLabelTapped()
    func saveCustomNutrientsPercentageFor(proteins: Int, carbohydrates: Int, fats: Int)
}

protocol NutritionSettingViewModelInput: AnyObject {
    
    func loadCurrentNutritionMode(to nutritionMode: UserInfo.NutritionMode)
    func changeNutritionSelection(to nutritionMode: UserInfo.NutritionMode)
    
    func updateNutritionRecomandation(to nutritionRecomendation: NutritionRecomendation)
    func customCaloriesWasSet(to calories: Int)
    func updateCutomNutritionInfo(for nutritionInfo: NutritionRecomendation)
    
}

final class NutritionSettingViewModel {
    
    weak var view: NutritionSettingView?
    private var model: NutritionSettingModelProtocol
    var router: NutritionSettingRouterProtocol?
    private var _selectedModeIndex: Int = 0
    
    init(model: NutritionSettingModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionSettingViewModelProtocol
extension NutritionSettingViewModel: NutritionSettingViewModelProtocol {
    
    func makronutrientsPercentageLabelTapped() {
        model.getNutritionInfoForCustomMode()
    }
    
    func saveCustomNutrientsPercentageFor(proteins: Int, carbohydrates: Int, fats: Int) {
        model.saveCustomnutritionPercentageFor(proteins: proteins, carbohydrates: carbohydrates, fats: fats)
    }

    func saveCustomCalories(calories: String?) {
        guard let numericCalories = Int(calories ?? "0") else { return }
        model.saveCustomCalories(calories: numericCalories)
    }
    
    func selectRow(at index: Int) {
        model.changeSelectedNutritionMode(to: settingModel[index])
    }
    
    func saveButtonPressed() {
        model.saveNewNutritionMode()
        router?.popViewController()
    }
    
    func viewDidLoad() {
        model.getSelectednutritionMode()
    }
    
    var settingModel: [UserInfo.NutritionMode] {
        return [.loseWeight, .balanceWeight, .weightGain, .custom]
    }
    
    var selectedIndex: Int {
        _selectedModeIndex
    }
}

// MARK: - NutritionSettingViewModelInput
extension NutritionSettingViewModel: NutritionSettingViewModelInput {
    
    func updateCutomNutritionInfo(for nutritionInfo: NutritionRecomendation) {
        view?.showNutrientsPickerWithPercentageFor(proteins: Int(nutritionInfo.proteinsPercentage),
                                                   carbohydrates:  Int(nutritionInfo.carbohydratesPercentage),
                                                   fats:  Int(nutritionInfo.fatsPercentage))
    }

    func customCaloriesWasSet(to calories: Int) {
        view?.updateCustomCaloriesLabel(to: String(calories) + " kkal.")
    }
     
    func updateNutritionRecomandation(to nutritionRecomendation: NutritionRecomendation) {
        let calories = String(Int(nutritionRecomendation.calories.rounded())) + " kkal."
        let proteins = String(Int(nutritionRecomendation.proteinsPercentage.rounded())) + " %"
        let fats = String(Int(nutritionRecomendation.fatsPercentage.rounded())) + " %"
        let carbohydrates = String(Int(nutritionRecomendation.carbohydratesPercentage.rounded())) + " %"
        view?.updateNutritionInfo(for: calories, proteins: proteins, fats: fats, carbohydrates: carbohydrates)
    }
  
    func changeNutritionSelection(to nutritionMode: UserInfo.NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        _selectedModeIndex = indexOfSelectedMode
        nutritionMode == .custom ? view?.activateCustomEditingMode() : view?.deactivateCustomEditingmode()
        view?.selectMode(at: indexOfSelectedMode)
    }
    
    func loadCurrentNutritionMode(to nutritionMode: UserInfo.NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        nutritionMode == .custom ? view?.activateCustomEditingMode() : view?.deactivateCustomEditingmode()
        _selectedModeIndex = indexOfSelectedMode
    }
}
