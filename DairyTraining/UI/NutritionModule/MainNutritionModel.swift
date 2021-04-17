import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation? { get }
    var nutritionData: NutritionDataMO { get }
    var nutritionMode: UserInfo.NutritionMode { get }
    
    var meals: [NutritionService.MealTime: [MealMO]] { get }
    
    func loadData()
    
    func deleteMeal(at indexPath: IndexPath)
    func rowInSection(_ section: Int) -> Int
    func meal(at indexPath: IndexPath) -> MealMO?
    func titleForSection(_ section: Int) -> String
    func shouldShowSection(at index: Int) -> Bool
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
    private var userInfo: UserInfoMO?
    private let persistenceService: PersistenceServiceProtocol
    
    private var _meals: [NutritionService.MealTime: [MealMO]] = [:]
    
    // MARK: - Initialization
    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
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
        if persistenceService.user.userInfo.userNutritionMode == .custom {
            _recomendation = NutritionRecomendation(customNutritionRecomendation: persistenceService.nutrition.customNutritionMode)
        } else {
            _recomendation = calculator?.getRecomendation(for: persistenceService.user.userInfo.userNutritionMode)
        }
    }
    
    @objc private func nutritionModeChanged() {
        updateRecomendation()
        output?.updateMealPlaneMode(to: persistenceService.user.userInfo.userNutritionMode)
    }
    
    @objc private func mealWasAdded() {
        _meals[.breakfast] = persistenceService.nutrition.getMeals(for: .breakfast)
        _meals[.lunch] = persistenceService.nutrition.getMeals(for: .lunch)
        _meals[.dinner] = persistenceService.nutrition.getMeals(for: .dinner)
        output?.updateMeals()
    }
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    
    func shouldShowSection(at index: Int) -> Bool {
        guard let mealTime = NutritionService.MealTime(rawValue: index) else { return false }
        guard let section = _meals[mealTime] else { return false }
        return !section.isEmpty
    }
    
    func titleForSection(_ section: Int) -> String {
        guard let mealTime = NutritionService.MealTime(rawValue: section) else { return "" }
        return mealTime.title
    }
    
    
    func meal(at indexPath: IndexPath) -> MealMO? {
        guard let mealTime = NutritionService.MealTime(rawValue: indexPath.section) else { return nil }
        let section = _meals[mealTime]
        return section?[indexPath.row]
    }
    
    func rowInSection(_ section: Int) -> Int {
        guard let mealTime = NutritionService.MealTime(rawValue: section) else { return 0 }
        return _meals[mealTime]?.count ?? 0
    }
    
    
    var meals: [NutritionService.MealTime : [MealMO]] {
        return _meals
    }
    
    func deleteMeal(at indexPath: IndexPath) {
        guard let mealTime = NutritionService.MealTime(rawValue: indexPath.section) else { return }
        guard let section = _meals[mealTime] else { return }
        
        let mealForDeleting = section[indexPath.row]
        _meals[mealTime]?.remove(at: indexPath.row)
        persistenceService.nutrition.removeMeal(meal: mealForDeleting)
        output?.mealWasDeleteAt(mealTimeIndex: indexPath.section, and: indexPath.row)
    }
    
    func loadData() {
        _meals[.breakfast] = persistenceService.nutrition.getMeals(for: .breakfast)
        _meals[.lunch] = persistenceService.nutrition.getMeals(for: .lunch)
        _meals[.dinner] = persistenceService.nutrition.getMeals(for: .dinner)
        
        
        _nutritionData = persistenceService.nutrition.todayNutritionData
        calculator = CaloriesRecomendationCalculator(userInfo: persistenceService.user.userInfo)
        
        updateRecomendation()
        output?.updateMealPlane()
    }
    
    var nutritionData: NutritionDataMO {
        persistenceService.nutrition.todayNutritionData
    }
    
    var nutritionMode: UserInfo.NutritionMode {
        persistenceService.user.userInfo.userNutritionMode
    }
    
    var recomendation: NutritionRecomendation? {
        _recomendation
    }
}
