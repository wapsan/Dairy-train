import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
    var nutritionMode: NutritionMode { get }
    
    func loadData()
    
    func coordinatuToSearchFoodsScreen()
    func coordinateToNutritionSettingScreen()
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
        addObserverForMealAdded()
    }
    
    // MARK: - Private methods
    private func addObserverForChangingNutritionMode() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(nutritionModeChanged),
                                               name: .nutritionmodeWasChanged,
                                               object: nil)
    }
    
    private func addObserverForMealAdded() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mealWasAdded),
                                               name: .mealWasAddedToDaily,
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
    
    @objc private func mealWasAdded() {
        output?.updateMeals()
    }
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    
    func coordinateToNutritionSettingScreen() {
        MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.nutritionSetting)
    }
    
    func coordinatuToSearchFoodsScreen() {
        MainCoordinator.shared.coordinateChild(to: NutritionModuleCoordinator.Target.searchFood)
    }

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
