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
        return todayNutritionData
    }
    
    private func fetchTodayNutritionData() -> NutritionDataMO? {
        let fetchRequest: NSFetchRequest<NutritionDataMO> = NutritionDataMO.fetchRequest()
        return try? context.fetch(fetchRequest).first
    }
    
    
    // MARK: - Public properties
    var todayNutritionData: NutritionDataMO {
        guard let todayNutritionData = fetchTodayNutritionData() else {
            return createTodayNutritionData()
        }
        return todayNutritionData
    }
    
    private func convertToManagedObject(from meal: MealModel) -> MealMO {
        let newMeal = MealMO.init(context: context)
        newMeal.calories = meal.kkal
        newMeal.name = meal.mealName
        newMeal.proteins = meal.proteins
        newMeal.carbohydrates = meal.carbohydrates
        newMeal.fats = meal.fats
        return newMeal
    }
    
    private func convertToMealModel(from mealMO: MealMO) -> MealModel {
        return MealModel(mealName: mealMO.name ?? "",
                         weight: mealMO.weight,
                         kkal: mealMO.calories,
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
    
    func removeMeal(_ food: MealModel, at index: Int) {
        let mealForDeleting = todayNutritionData.mealsArray[index]
        todayNutritionData.removeFromMeals(mealForDeleting)
        updateContext()
    }
    
    func getMealsForBreakfast() -> [MealModel] {
        var mealModel: [MealModel] = []
        todayNutritionData.mealsArray.forEach({
            if DateHelper.shared.hours(for: $0.date) < 12 {
                mealModel.append(convertToMealModel(from: $0))
            }
        })
        return mealModel
    }
    
    func getMealForLunsh() -> [MealModel] {
        var mealModel: [MealModel] = []
        todayNutritionData.mealsArray.forEach({
            if DateHelper.shared.hours(for: $0.date) > 12 || DateHelper.shared.hours(for: $0.date) < 17 {
                mealModel.append(convertToMealModel(from: $0))
            }
        })
        return mealModel
    }
    
    func getMealForDinner() -> [MealModel] {
        var mealModel: [MealModel] = []
        todayNutritionData.mealsArray.forEach({
            if DateHelper.shared.hours(for: $0.date) > 17 {
                mealModel.append(convertToMealModel(from: $0))
            }
        })
        return mealModel
    }
}
