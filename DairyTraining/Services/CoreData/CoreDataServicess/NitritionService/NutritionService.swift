import Foundation
import CoreData

protocol NutritionServiceProtocol {
    
    var customNutritionMode: CustomNutritionModeMO { get }
    var todayNutritionData: NutritionDataMO { get }
    
    //MARK: - Nutrition data
    func fetchAllNutritionData() -> [NutritionDataMO]
    
    func createTodayNutritionData() -> NutritionDataMO
    func fetchTodayNutritionData() -> NutritionDataMO?
    
    //MARK: - Custom nutrition mode
    func createCustomNutritionMode() -> CustomNutritionModeMO
    func fetchCustomNutritionMode() -> CustomNutritionModeMO?
    func updateCustomNutritionMode(calories: Int)
    func updateCustomNutritionModePercentage(protein: Float, carbohydrates: Float, fats: Float)
    
    //MARK: - Meals
    func getMeals(for mealTime: NutritionModel.MealTime) -> [MealMO]
    func addMeal(meal: MealResponseModel)
    func removeMeal(meal: MealMO)
    
    //MARK: - Sync
    func syncCustomNutritonMode(from customNutritionMode: CustomNutritionCodableModel?)
    func syncAllNutritionData(from allNutritionData: [DayNutritionCodableModel])
    
    //MARK: - Remove
    func removeAllNutritonData()
}

final class NutritionService {
    
    
    
    
    //MARK: - Properies
    private let storeType: PersistentStoreType
    
    private var context: NSManagedObjectContext {
        DataBase.shared.nutritionContexttype(type: storeType)
    }
    
    //MARK: - Initialization
    init(storeType: PersistentStoreType = .prod) {
        self.storeType = storeType
    }
    
    //MARK: - Private methods
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Cannot save context")
        }
    }
    
    fileprivate func getBreakfastMeals() -> [MealMO] {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        let hourPredicate = NSPredicate(format: "hour < 12")
        let formadetDate = DateHelper.shared.getFormatedDate(date: .now, dateFromat: MealMO.dateFormat)
        let datePredicate = NSPredicate(format: "formatedDate == %@", formadetDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [hourPredicate, datePredicate])
        guard let breakfastMeals = try? context.fetch(fetchRequest) else { return [] }
        return breakfastMeals
    }
    
    fileprivate func getLunchMeals() -> [MealMO] {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        let hourPredicate = NSPredicate(format: "hour >= 12 AND hour <= 17")
        let formadetDate = DateHelper.shared.getFormatedDate(date: .now, dateFromat: MealMO.dateFormat)
        let datePredicate = NSPredicate(format: "formatedDate == %@", formadetDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [hourPredicate, datePredicate])
        guard let breakfastMeals = try? context.fetch(fetchRequest) else { return [] }
        return breakfastMeals
    }
    
    fileprivate func getDinnerMeals() -> [MealMO] {
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        let hourPredicate = NSPredicate(format: "hour > 17")
        let formadetDate = DateHelper.shared.getFormatedDate(date: .now, dateFromat: MealMO.dateFormat)
        let datePredicate = NSPredicate(format: "formatedDate == %@", formadetDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [hourPredicate, datePredicate])
        guard let breakfastMeals = try? context.fetch(fetchRequest) else { return [] }
        return breakfastMeals
    }
    
    fileprivate func convertToManagedObject(from meal: MealResponseModel) -> MealMO {
        let newMeal = MealMO.init(context: context)
        newMeal.date = Date()
        newMeal.hour = Int32(DateHelper.shared.hours(for: .now))
        newMeal.weight = meal.weight
        newMeal.calories = meal.calories
        newMeal.name = meal.mealName
        newMeal.proteins = meal.proteins
        newMeal.carbohydrates = meal.carbohydrates
        newMeal.fats = meal.fats
        return newMeal
    }
}

//MARK: - NutritionServiceProtocol
extension NutritionService: NutritionServiceProtocol {
    
    var todayNutritionData: NutritionDataMO {
        var nutritionData: NutritionDataMO
        
        switch fetchTodayNutritionData() {
        case .none:
            nutritionData = createTodayNutritionData()
            
        case .some(let nutritioData):
            nutritionData = nutritioData
            
        }
        
        return nutritionData
    }
    
    var customNutritionMode: CustomNutritionModeMO {
        var customNutritionMode: CustomNutritionModeMO
        
        switch fetchCustomNutritionMode() {
        case .none:
            customNutritionMode = createCustomNutritionMode()
            
        case .some(let mode):
            customNutritionMode = mode
            
        }
        
        return customNutritionMode
    }
    
    func fetchAllNutritionData() -> [NutritionDataMO] {
        let fetchRequest: NSFetchRequest<NutritionDataMO> = NutritionDataMO.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func createTodayNutritionData() -> NutritionDataMO {
        let todayNutritionData = NutritionDataMO.init(context: context)
        todayNutritionData.date = .now
        todayNutritionData.formatedDate = DateHelper.shared.getFormatedDate(date: .now,
                                                                            dateFromat: NutritionDataMO.dateFormat)
        return todayNutritionData
    }
    
    func fetchTodayNutritionData() -> NutritionDataMO? {
        let fetchRequest: NSFetchRequest<NutritionDataMO> = NutritionDataMO.fetchRequest()
        let formatedDate = DateHelper.shared.getFormatedDate(date: .now, dateFromat: NutritionDataMO.dateFormat)
        let predicate = NSPredicate(format: "formatedDate == %@", formatedDate)
        fetchRequest.predicate = predicate
        return try? context.fetch(fetchRequest).first
    }
    
    func createCustomNutritionMode() -> CustomNutritionModeMO {
        let customMode = CustomNutritionModeMO.init(context: context)
        return customMode
    }
    
    func fetchCustomNutritionMode() -> CustomNutritionModeMO? {
        let fetchRequest: NSFetchRequest<CustomNutritionModeMO> = CustomNutritionModeMO.fetchRequest()
        return try? context.fetch(fetchRequest).first
    }
    
    func updateCustomNutritionMode(calories: Int) {
        let newProteins = (customNutritionMode.proteinPrescentage * calories.float) / 4
        let newCarbohydrates = (customNutritionMode.carbohydratesPercentage * calories.float) / 4
        let newFats = (customNutritionMode.fatsPercentage * calories.float) / 9
        
        customNutritionMode.calories = calories.float
        customNutritionMode.fats = newFats
        customNutritionMode.proteins = newProteins
        customNutritionMode.carbohydrates = newCarbohydrates
        saveContext()
    }
    
    func updateCustomNutritionModePercentage(protein: Float, carbohydrates: Float, fats: Float) {
        let newProtein = (protein.asPercents() * customNutritionMode.calories) / 4
        let newCarbohydrates = (carbohydrates.asPercents() * customNutritionMode.calories) / 4
        let newFats = (fats.asPercents() * customNutritionMode.fats) / 9
        
        customNutritionMode.proteins = newProtein
        customNutritionMode.carbohydrates = newCarbohydrates
        customNutritionMode.fats = newFats
        saveContext()
    }
    
    func getMeals(for mealTime: NutritionModel.MealTime) -> [MealMO] {
        switch mealTime {
        case .breakfast:
            return getBreakfastMeals()
        
        case .lunch:
            return getLunchMeals()
            
        case .dinner:
            return getDinnerMeals()
            
        }
    }
    
    func addMeal(meal: MealResponseModel) {
        let newMeal = convertToManagedObject(from: meal)
        newMeal.nutritionData = todayNutritionData
        newMeal.formatedDate = DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat)
        todayNutritionData.addToMeals(newMeal)
        saveContext()
    }
    
    func removeMeal(meal: MealMO) {
        context.delete(meal)
        saveContext()
    }
    
    func syncCustomNutritonMode(from customNutritionMode: CustomNutritionCodableModel?) {
        guard let mode = customNutritionMode else { return }
        let newMode = CustomNutritionModeMO(context: context)
        newMode.calories = mode.calories
        newMode.proteins = mode.proteins
        newMode.carbohydrates = mode.carbohydrates
        newMode.fats = mode.fats
        saveContext()
    }
    
    func syncAllNutritionData(from allNutritionData: [DayNutritionCodableModel]) {
        allNutritionData.forEach({ day in
            let newDay = NutritionDataMO(context: context)
            newDay.date = day.date
            newDay.formatedDate = day.formattedDate
            for meal in day.meals {
                let newMeal = MealMO(context: context)
                newMeal.calories = meal.calories
                newMeal.proteins = meal.proteins
                newMeal.fats = meal.fats
                newMeal.weight = meal.weigght
                newMeal.hour = meal.hour
                newMeal.name = meal.name
                newMeal.nutritionData = newDay
                newMeal.carbohydrates = meal.carbohydrates
                newMeal.date = meal.date
                newDay.addToMeals(newMeal)
            }
        })
        saveContext()
    }
    
    func removeAllNutritonData() {
        fetchAllNutritionData().forEach({ context.delete($0) })
        context.delete(customNutritionMode)
        saveContext()
    }
}
