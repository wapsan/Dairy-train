import Foundation
import CoreData

final class NutritionDataManager {
    
    // MARK: - Singletone fields
    static let shared = NutritionDataManager()
    private init() {}
    
    //MARK: - Private properties
    private let dataModelName = "NutritionDataModel"
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.dataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return self.container.viewContext
    }()
    
    //MARK: - Private methods
    private func updateContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("TrainInfoContext dont't update")
        }
    }
    
    private func createTodayNutritionData() -> NutritionDataMO {
        let todayNutritionData = NutritionDataMO.init(context: context)
        todayNutritionData.date = Date()
        todayNutritionData.formatedDate = DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat)
        return todayNutritionData
    }
    
    private func fetchTodayNutritionData() -> NutritionDataMO? {
        let fetchRequest: NSFetchRequest<NutritionDataMO> = NutritionDataMO.fetchRequest()
        let predicate = NSPredicate(
            format: "formatedDate == %@",
            DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat))
        fetchRequest.predicate = predicate
        return try? context.fetch(fetchRequest).first
    }
    
    private func createCustomNutritionMode() -> CustomNutritionModeMO {
        let todayNutritionData = CustomNutritionModeMO.init(context: context)
        return todayNutritionData
    }
    
    private func fetchCustomNutritionMode() -> CustomNutritionModeMO? {
        let fetchRequest: NSFetchRequest<CustomNutritionModeMO> = CustomNutritionModeMO.fetchRequest()
        return try? context.fetch(fetchRequest).first
    }
    
    // MARK: - Public properties
    var todayNutritionData: NutritionDataMO {
        guard let todayNutritionData = fetchTodayNutritionData() else {
            return createTodayNutritionData()
        }
        return todayNutritionData
    }
    
    var customNutritionMode: CustomNutritionModeMO {
        guard let customnutritionMode = fetchCustomNutritionMode() else {
            return createCustomNutritionMode()
        }
        return customnutritionMode
    }
    
    private func convertToManagedObject(from meal: MealModel) -> MealMO {
        let newMeal = MealMO.init(context: context)
        newMeal.date = Date()
        newMeal.hour = Int32(DateHelper.shared.hours(for: Date()))
        newMeal.weight = meal.weight
        newMeal.calories = meal.calories
        newMeal.name = meal.mealName
        newMeal.proteins = meal.proteins
        newMeal.carbohydrates = meal.carbohydrates
        newMeal.fats = meal.fats
        return newMeal
    }
    
    private func convertToMealModel(from mealMO: MealMO) -> MealModel {
        return MealModel(mealName: mealMO.name ?? "",
                         weight: mealMO.weight,
                         calories: mealMO.calories,
                         proteins: mealMO.proteins,
                         carbohydrates: mealMO.carbohydrates,
                         fats: mealMO.fats)
    }
    
    // MARK: - Public methods
    func addMeal(_ meal: MealModel) {
        let newMeal = convertToManagedObject(from: meal)
        newMeal.nutritionData = todayNutritionData
        todayNutritionData.addToMeals(newMeal)
        updateContext()
    }
    
    func removeMealFromBreakfast(at index: Int) {
        let mealForDeleting = getBreakfastMealMO()[index]
        context.delete(mealForDeleting)
        updateContext()
    }
    
    func removeMealFrombLunch(at index: Int) {
        let mealForDeleting = getLunchMealMO()[index]
        context.delete(mealForDeleting)
        updateContext()
    }
    
    func removeMealFromDinner(at index: Int) {
        let mealForDeleting = getDinnerMealMO()[index]
        context.delete(mealForDeleting)
        updateContext()
    }
    
    private func getBreakfastMealMO() -> [MealMO] {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        let predicate = NSPredicate(format: "hour < 12")
        fetchRequest.predicate = predicate
        guard let breakfastMeals = try? context.fetch(fetchRequest) else { return [] }
        return breakfastMeals
    }
    
    private func getLunchMealMO() -> [MealMO] {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        let predicate = NSPredicate(format: "hour >= 12 AND hour <= 17")
        fetchRequest.predicate = predicate
        guard let breakfastMeals = try? context.fetch(fetchRequest) else { return [] }
        return breakfastMeals
    }
    
    private func getDinnerMealMO() -> [MealMO] {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        let predicate = NSPredicate(format: "hour > 17")
        fetchRequest.predicate = predicate
        guard let breakfastMeals = try? context.fetch(fetchRequest) else { return [] }
        return breakfastMeals
    }
    
    
    func getMealsForBreakfast() -> [MealModel] {
        var mealModel: [MealModel] = []
        getBreakfastMealMO().forEach({
            mealModel.append(convertToMealModel(from: $0))
        })
        return mealModel
    }
    
    func getMealForLunsh() -> [MealModel] {
        var mealModel: [MealModel] = []
        getLunchMealMO().forEach({
            mealModel.append(convertToMealModel(from: $0))
        })
        return mealModel
    }
    
    func getMealForDinner() -> [MealModel] {
        var mealModel: [MealModel] = []
        getDinnerMealMO().forEach({
            mealModel.append(convertToMealModel(from: $0))
        })
        return mealModel
    }
    
    func updateCustomCalories(to calories: Int) {
        let proteinPercentage = (customNutritionMode.proteins * 4) / customNutritionMode.calories
        let fatsPercentage = (customNutritionMode.fats * 9) / customNutritionMode.calories
        let carbohydratesPercentage = (customNutritionMode.carbohydrates * 4) / customNutritionMode.calories
        
        let proteins = (Float(proteinPercentage) * Float(calories)) / 4
        let carbohydrates = (Float(carbohydratesPercentage) * Float(calories)) / 4
        let fats = (Float(fatsPercentage) * Float(calories)) / 9
        
        customNutritionMode.calories = Float(calories)
        customNutritionMode.proteins = proteins
        customNutritionMode.carbohydrates = carbohydrates
        customNutritionMode.fats = fats
        updateContext()
    }
    
    func updateCustomPercentageFor(proteinsPercentage: Float, carbohydratesPercentage: Float, fatsPercentage: Float) {
        let proteins = (Float(proteinsPercentage / 100) * customNutritionMode.calories) / 4
        let carbohydrates = (Float(carbohydratesPercentage / 100) * customNutritionMode.calories) / 4
        let fats = (Float(fatsPercentage / 100) * customNutritionMode.calories) / 9
        customNutritionMode.proteins = proteins
        customNutritionMode.carbohydrates = carbohydrates
        customNutritionMode.fats = fats
        updateContext()
    }
    
    func updateCustomNutritionMode(from cutomRecomendation: NutritionRecomendation) {
        customNutritionMode.calories = cutomRecomendation.calories
        customNutritionMode.proteins = cutomRecomendation.proteinsPercentage
        customNutritionMode.carbohydrates = cutomRecomendation.carbohydratesPercentage
        customNutritionMode.fats = cutomRecomendation.fatsPercentage
        updateContext()
    }
}
