import Foundation

protocol NutritionModelProtocol {
    var recomendation: NutritionRecomendation { get }
    var nutritionData: NutritionDataMO { get }
    var nutritionMode: UserInfo.NutritionMode { get }
    
    var sections: [NutritionModel.NutritionSection] { get }
    
    func loadData()
    func reloadInformation()
    
    func deleteMeal(at indexPath: IndexPath)
    func rowInSection(_ section: Int) -> Int
    func meal(at indexPath: IndexPath) -> MealMO?
    func titleForSection(_ section: Int) -> String
    func shouldShowSection(at index: Int) -> Bool
}

final class NutritionModel {
    
    // MARK: - Module Properties
    weak var output: NutritionModelOutput?
    
    // MARK: - Properties
    private lazy var _recomendation: NutritionRecomendation = NutritionRecomendation(userInfo: persistenceService.user.userInfo,
                                                                                     nutrtitonMode: persistenceService.user.userInfo.userNutritionMode,
                                                                                     customNutritionMode: persistenceService.nutrition.customNutritionMode) {
        didSet {
            output?.reloadInformation()
        }
    }

    private let persistenceService: PersistenceServiceProtocol
    private var shouldReloadInformation = false
    
    private var _sections: [NutritionSection] = []
    
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
        _recomendation = NutritionRecomendation(userInfo: persistenceService.user.userInfo,
                                                nutrtitonMode: persistenceService.user.userInfo.userNutritionMode,
                                                customNutritionMode: persistenceService.nutrition.customNutritionMode)
    }
    
    @objc private func nutritionModeChanged() {
        updateRecomendation()
        output?.reloadInformation()
    }
    
    @objc private func mealWasAdded() {
        switch DateHelper.shared.hours(for: .now) {
        case let hour where hour >= 12 && hour <= 17:
            guard let lunchSectionIndex = _sections.firstIndex(where: { $0.title == "Lunch" }) else { return }
            let actualLunchMeals = persistenceService.nutrition.getMeals(for: .lunch)
            actualLunchMeals.forEach({ meal in
                if !_sections[lunchSectionIndex].meals.contains(meal) {
                    _sections[lunchSectionIndex].meals.append(meal)
                    output?.reloadSection(ar: lunchSectionIndex)
                }
            })
        
        case let hour where  hour < 12:
            guard let lunchSectionIndex = _sections.firstIndex(where: { $0.title == "Breakfast" }) else { return }
            let actualLunchMeals = persistenceService.nutrition.getMeals(for: .breakfast)
            actualLunchMeals.forEach({ meal in
                if !_sections[lunchSectionIndex].meals.contains(meal) {
                    _sections[lunchSectionIndex].meals.append(meal)
                    output?.reloadSection(ar: lunchSectionIndex)
                }
            })
            
        case let hour where  hour > 17:
            guard let dinnerSectionIndex = _sections.firstIndex(where: { $0.title == "Dinner" }) else { return }
            let actualLunchMeals = persistenceService.nutrition.getMeals(for: .dinner)
            actualLunchMeals.forEach({ meal in
                if !_sections[dinnerSectionIndex].meals.contains(meal) {
                    _sections[dinnerSectionIndex].meals.append(meal)
                    output?.reloadSection(ar: dinnerSectionIndex)
        
                }
            })
            
        default:
            break
        }
        shouldReloadInformation = true
    }
}

// MARK: - NutritionModelProtocol
extension NutritionModel: NutritionModelProtocol {
    
    func reloadInformation() {
         guard shouldReloadInformation else { return }
         output?.reloadInformation()
         shouldReloadInformation = false
    }
    
    var sections: [NutritionSection] {
        return _sections
    }
    
    func shouldShowSection(at index: Int) -> Bool {
        guard index != 0 else { return false }
        let melsInSections = _sections[index].meals
        return !melsInSections.isEmpty
    }
    
    func titleForSection(_ section: Int) -> String {
        return _sections[section].title ?? ""
    }
    
    
    func meal(at indexPath: IndexPath) -> MealMO? {
        return _sections[indexPath.section].meals[indexPath.row]
    }
    
    func rowInSection(_ section: Int) -> Int {
        return _sections[section].numberOfItems
    }
    
    func deleteMeal(at indexPath: IndexPath) {
        let mealForDeleting = _sections[indexPath.section].meals[indexPath.row]
        persistenceService.nutrition.removeMeal(meal: mealForDeleting)
        _sections[indexPath.section].meals.remove(at: indexPath.row)
        output?.deleteMeal(at: indexPath)
    }
    
    func loadData() {
       
        _sections.append(.init(meals: [], title: nil, type: .information))
        
        NutritionModel.MealTime.allCases.forEach({
            _sections.append(.init(meals: persistenceService.nutrition.getMeals(for: $0),
                                   title: $0.title,
                                   type: .meals))
        })
        
        updateRecomendation()
        output?.reloadInformation()
    }
    
    var nutritionData: NutritionDataMO {
        persistenceService.nutrition.todayNutritionData
    }
    
    var nutritionMode: UserInfo.NutritionMode {
        persistenceService.user.userInfo.userNutritionMode
    }
    
    var recomendation: NutritionRecomendation {
        _recomendation
    }
}


