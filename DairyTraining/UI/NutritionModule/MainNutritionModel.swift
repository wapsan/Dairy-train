import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
    var nutritionMode: NutritionMode { get }
    
    func loadData()
    
    func deleteMeal(at mealTimeIndex: Int, mealIndex: Int)
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
    private var nutritionManager = NutritionDataManager.shared
    
    // MARK: - Initialization
    init() {
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
    
    func deleteMeal(at mealTimeIndex: Int, mealIndex: Int) {
        let mealTime = TodayMealNutritionModel.allCases[mealTimeIndex]
        switch mealTime {
        case .mainCell:
            break
        case .breakfast:
            nutritionManager.removeMealFromBreakfast(at: mealIndex)
        case .lunch:
            nutritionManager.removeMealFrombLunch(at: mealIndex)
        case .dinner:
            nutritionManager.removeMealFromDinner(at: mealIndex)
        }
        output?.mealWasDeleteAt(mealTimeIndex: mealTimeIndex, and: mealIndex)
    }
    
    func loadData() {
        _nutritionData = NutritionDataManager.shared.todayNutritionData
        guard let user = UserDataManager.shared.readUserMainInfo() else { return }
        calculator = CaloriesRecomendationCalculator(userInfo: user)
        updateRecomendation()
        output?.updateMealPlane()
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
