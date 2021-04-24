import Foundation

struct NutritionDataPresentable {
    let date: Date?
    let calories: Float
    let proteins: Float
    let carbohydrates: Float
    let fats: Float
    
    var displayCalories: Int {
        return Int(calories.rounded())
    }
    
    var displayFats: Int {
        return Int(fats.rounded())
    }
    
    var displayProteins: Int {
        return Int(proteins.rounded())
    }
    
    var displayCarbohydrates: Int {
        return Int(carbohydrates.rounded())
    }
    
    var displayDate: String? {
        guard let date = self.date else { return nil }
        return DateHelper.shared.getFormatedDateFrom(date, with: .dateForDailyCaloriessIntakeFormat)
    }
 
    init(nutritionDataMO: NutritionDataMO) {
        self.date = nutritionDataMO.date
        var summCalories: Float = 0
        nutritionDataMO.mealsArray.forEach({
            summCalories += $0.calories
        })
        self.calories = summCalories
        var sumProteins: Float = 0
        nutritionDataMO.mealsArray.forEach({
            sumProteins += $0.proteins
        })
        self.proteins = sumProteins
        var sunCarbohydrates: Float = 0
        nutritionDataMO.mealsArray.forEach({
            sunCarbohydrates += $0.carbohydrates
        })
        self.carbohydrates = sunCarbohydrates
        var sumFats: Float = 0
        nutritionDataMO.mealsArray.forEach({
            sumFats += $0.fats
        })
        self.fats = sumFats
    }
}

protocol NutritionViewModelProtocol {
    
    var nutritionRecomendation: NutritionRecomendation? { get }
    var userNutritionData: NutritionDataPresentable { get }
    
    func viewDidLoad()
    func addMealButtonPressed()
    func settinButtonPressed()
    
    //MARK: - New
    var sectioncount: Int { get }
    func rowInSection(section: Int) -> Int
    func didSwipeCell(at indexPath: IndexPath)
    func meal(at indexPath: IndexPath) -> MealMO?
    func titleForSection(_ section: Int) -> String
    func shouldShowHeader(in section: Int) -> Bool
    func viewWillAppear()
}

protocol NutritionModelOutput: AnyObject {
    func updateMeals()
    func deleteMeal(at indexPath: IndexPath)
    func reloadSection(ar index: Int)
    func reloadInformation()
}

final class NutritionViewModel {
    
    // MARK: - Module properties
    weak var view: MainNutritionView?
    var router: MainNutritionRouterProtocol?
    
    // MARK: - Private Properties
    private let model: NutritionModelProtocol
    
    private var informationCellIndexPath: IndexPath {
        IndexPath(row: 0, section: 0)
    }
    
    // MARK: - Initialization
    init(model: NutritionModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionViewModelProtocol
extension NutritionViewModel: NutritionViewModelProtocol {
    
    func viewWillAppear() {
        model.reloadInformation()
    }
    
    func shouldShowHeader(in section: Int) -> Bool {
        model.shouldShowSection(at: section)
    }
    
    func titleForSection(_ section: Int) -> String {
        model.titleForSection(section)
    }
    
    func meal(at indexPath: IndexPath) -> MealMO? {
        return model.meal(at: indexPath)
    }
    
    func didSwipeCell(at indexPath: IndexPath) {
        model.deleteMeal(at: indexPath)
    }
    
    var sectioncount: Int {
        return model.sections.count
    }
    
    func rowInSection(section: Int) -> Int {
        model.rowInSection(section)
    }
    
    func settinButtonPressed() {
        router?.showNutritionSettingScreen()
    }
    
    func addMealButtonPressed() {
        router?.showSearchFoodScreen()
    }
    
    func viewDidLoad() {
        model.loadData()
    }
    
    var userNutritionData: NutritionDataPresentable {
        return NutritionDataPresentable(nutritionDataMO: model.nutritionData)
    }

    var nutritionRecomendation: NutritionRecomendation? {
        return model.recomendation
    }
}

// MARK: - NutritionViewModelInput
extension NutritionViewModel: NutritionModelOutput {
    
    func deleteMeal(at indexPath: IndexPath) {
        view?.deleteRow(at: indexPath)
        view?.reloadRow(at: informationCellIndexPath)
    }
    
    func reloadInformation() {
        view?.reloadRow(at: informationCellIndexPath)
    }
    
    func reloadSection(ar index: Int) {
        view?.reloadSection(at: index)
    }

    func updateMeals() {
        view?.reloadTableView()
    }
}
