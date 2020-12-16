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
    
    func changeNutritionSelection(to nutritionMode: NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        _selectedModeIndex = indexOfSelectedMode
        view?.selectMode(at: indexOfSelectedMode)
    }
    
    func loadCurrentNutritionMode(to nutritionMode: NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        _selectedModeIndex = indexOfSelectedMode
    }
}
