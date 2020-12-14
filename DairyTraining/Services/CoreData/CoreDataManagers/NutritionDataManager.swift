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
    
    private func createNutritionData(with food: Food) {
        let nutritionData = NutritionDataMO(context: context)
        nutritionData.calories = food.nutrients.kkal
        nutritionData.catbohidrates = food.nutrients.carbohydrates
        nutritionData.fats = food.nutrients.fat
        nutritionData.proteins = food.nutrients.proteins
        nutritionData.date = Date()
        updateContext()
    }
    
    private func addFoodToExitingNutritionData(_ food: Food) {
        guard let todaysNutritiontData = nutritionData.first else { return }
        todaysNutritiontData.calories += food.nutrients.kkal
        todaysNutritiontData.fats += food.nutrients.fat
        todaysNutritiontData.catbohidrates += food.nutrients.carbohydrates
        todaysNutritiontData.proteins += food.nutrients.proteins
        updateContext()
    }
    
    // MARK: - Properties
    var nutritionData: [NutritionDataMO] {
        let fetchRequest: NSFetchRequest<NutritionDataMO> = NutritionDataMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let nutritionData = try? context.fetch(fetchRequest) else { return [] }
        return nutritionData
    }
    
    // MARK: - Public methods
    func addMeal(_ food: Food) {
        guard nutritionData.isEmpty else {
            addFoodToExitingNutritionData(food)
            return
        }
        createNutritionData(with: food)
    }
    
    func deleteMeal(_ food: Food) {
        guard let todaysNutritiontData = nutritionData.first else { return }
        todaysNutritiontData.calories -= food.nutrients.kkal
        todaysNutritiontData.fats -= food.nutrients.fat
        todaysNutritiontData.catbohidrates -= food.nutrients.carbohydrates
        todaysNutritiontData.proteins -= food.nutrients.proteins
        updateContext()
    }
}
