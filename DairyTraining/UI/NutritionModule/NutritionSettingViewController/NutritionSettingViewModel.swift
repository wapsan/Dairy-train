import Foundation

protocol NutritionSettingViewModelProtocol {
    var settingModel: [NutritionMode] { get }
    
    func viewDidLoad()
    func selectRow(at index: Int)
    func deseloctRow(at index: Int)
    
    func saveButtonPressed()
}

protocol NutritionSettingViewModelInput: AnyObject {
    func updateCurrentNutritionMode(to nutritionMode: NutritionMode)
}

final class NutritionSettingViewModel {
    
    weak var view: NutritionSettingView?
    private var model: NutritionettingModelProtocol
    
    
    init(model: NutritionettingModelProtocol) {
        self.model = model
    }
}

extension NutritionSettingViewModel: NutritionSettingViewModelProtocol {
    
    func selectRow(at index: Int) {
        model.markNutritionModeAsSelected(settingModel[index])
    }
    
    func deseloctRow(at index: Int) {
        
    }
    
    func saveButtonPressed() {
        
    }
    
    func viewDidLoad() {
        model.getSelectednutritionMode()
    }
    
    var settingModel: [NutritionMode] {
        return [.loseWeight, .balanceWeight, .weightGain, .custom]
    }
}

extension NutritionSettingViewModel: NutritionSettingViewModelInput {
    
    func updateCurrentNutritionMode(to nutritionMode: NutritionMode) {
        guard let indexOfSelectedMode = settingModel.firstIndex(of: nutritionMode) else { return }
        view?.selectMode(at: indexOfSelectedMode)
    }
}
