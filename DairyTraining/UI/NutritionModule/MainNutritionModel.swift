import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
    var nutritionMode: NutritionMode { get }
    func loadData()
}

final class NutritionModel {
    
    // MARK: - Module Properties
    weak var output: NutritionViewModelInput?
    
    // MARK: - Properties
    private var _recomendation: NutritionRecomendation? {
        didSet {
            output?.recomendationWasChanged(to: _recomendation)
        }
    }
    private var _nutritionData: NutritionDataMO?
    private var calculator: CaloriesRecomendationCalculator?
    private var userInfo: MainInfoManagedObject?
    
    // MARK: - Initialization
    init(userInfo: MainInfoManagedObject?) {
        addObserverForChangingNutritionMode()
    }
    
    // MARK: - Private methods
    private func addObserverForChangingNutritionMode() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(nutritionModeChanged),
                                               name: .nutritionmodeWasChanged,
                                               object: nil)
    }
    
    private func updateRecomendation() {
        if UserDataManager.shared.getNutritionMode() == .custom {
            _recomendation = NutritionRecomendation(customNutritionRecomendation: NutritionDataManager.shared.customNutritionMode)
        } else {
            _recomendation = calculator?.getRecomendation(for: UserDataManager.shared.getNutritionMode())
        }
    }
    
    @objc private func nutritionModeChanged() {
        updateRecomendation()
        output?.updateMealPlaneMode(to: UserDataManager.shared.getNutritionMode())
    }
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    
    func loadData() {
        _nutritionData = NutritionDataManager.shared.todayNutritionData
        guard let user = UserDataManager.shared.readUserMainInfo() else { return }
        calculator = CaloriesRecomendationCalculator(userInfo: user)
        updateRecomendation()
    }
    
    var nutritionData: NutritionDataMO {
        NutritionDataManager.shared.todayNutritionData
    }
    
    var nutritionMode: NutritionMode {
        UserDataManager.shared.getNutritionMode()
    }
    var recomendation: NutritionRecomendation? {
        _recomendation
    }
}
