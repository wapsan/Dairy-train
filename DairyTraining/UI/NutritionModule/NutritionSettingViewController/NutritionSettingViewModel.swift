import Foundation

protocol NutritionSettingViewModelProtocol {
    var settingModel: [NutritionMode] { get }
    var selectedIndex: Int { get }
    
    func viewDidLoad()
    func selectRow(at index: Int)
    
    func saveButtonPressed()
}

protocol NutritionSettingViewModelInput: AnyObject {
    func loadCurrentNutritionMode(to nutritionMode: NutritionMode)
    func changeNutritionSelection(to nutritionMode: NutritionMode)
    
    func updateNutritionRecomandation(to nutritionRecomendation: NutritionRecomendation)
    func userInfoNotSet()
    
}

final class NutritionSettingViewModel {
    
    weak var view: NutritionSettingView?
    private var model: NutritionettingModelProtocol
    private var _selectedModeIndex: Int = 0
    
    init(model: NutritionettingModelProtocol) {
        self.model = model
    }
}

extension NutritionSettingViewModel: NutritionSettingViewModelProtocol {
    
    func selectRow(at index: Int) {
        model.changeSelectedNutritionMode(to: settingModel[index])
    }
    
    func saveButtonPressed() {
        model.saveNewNutritionMode()
        MainCoordinator.shared.popViewController()
    }
    
    func viewDidLoad() {
        model.getSelectednutritionMode()
    }
    
    var settingModel: [NutritionMode] {
        return [.loseWeight, .balanceWeight, .weightGain, .custom]
    }
    
    var selectedIndex: Int {
        _selectedModeIndex
    }
}

extension NutritionSettingViewModel: NutritionSettingViewModelInput {
    
    func updateNutritionRecomandation(to nutritionRecomendation: NutritionRecomendation) {
        let calories = String(Int(nutritionRecomendation.calories.rounded())) + " kkal."
        let proteins = String(Int(nutritionRecomendation.proteinsPercentage.rounded())) + " %"
        let fats = String(Int(nutritionRecomendation.fatsPercentage.rounded())) + " %"
        let carbohydrates = String(Int(nutritionRecomendation.carbohydratesPercentage.rounded())) + " %"
        view?.updateNutritionInfo(for: calories, proteins: proteins, fats: fats, carbohydrates: carbohydrates)
    }
    
    func userInfoNotSet() {
        
    }
    
    func changeNutritionSelection(to nutritionMode: NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        _selectedModeIndex = indexOfSelectedMode
        nutritionMode == .custom ? view?.activateCustomEditingMode() : view?.deactivateCustomEditingmode()
        view?.selectMode(at: indexOfSelectedMode)
        
    }
    
    func loadCurrentNutritionMode(to nutritionMode: NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        _selectedModeIndex = indexOfSelectedMode
    }
}
