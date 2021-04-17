
import Foundation

struct DayNutritionCodableModel: Mapable {
    let date: Date?
    let formattedDate: String?
    private(set) var meals: [MealCodableModel] = []
    
    init(from modelMO: NutritionDataMO) {
        self.date = modelMO.date
        self.formattedDate = modelMO.formatedDate
        modelMO.mealsArray.forEach({
            meals.append(MealCodableModel(from: $0))
        })
    }
    
}

struct MealCodableModel: Mapable {
    let calories: Float
    let carbohydrates: Float
    let date: Date
    let fats: Float
    let hour: Int32
    let name: String?
    let proteins: Float
    let weigght: Float
    
    init(from modelMO: MealMO) {
        self.calories = modelMO.calories
        self.proteins = modelMO.proteins
        self.fats = modelMO.fats
        self.carbohydrates = modelMO.carbohydrates
        self.weigght = modelMO.weight
        self.name = modelMO.name
        self.hour = modelMO.hour
        self.date = modelMO.date
    }
}

struct CustomNutritionCodableModel: Mapable {
    
    //MARK: - Keys
    private struct Key {
        static let calories = "calories"
        static let proteins = "proteins"
        static let fats = "fat"
        static let carbohydrates = "carbohydrates"
    }
    
    //MARK: - Properies
    let calories: Float
    let carbohydrates: Float
    let fats: Float
    let proteins: Float
    
    //MARK: - Publick methods
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[Key.proteins] = proteins
        dict[Key.calories] = calories
        dict[Key.carbohydrates] = carbohydrates
        dict[Key.fats] = fats
        return dict
    }
    
    //MARK: - Initialization
    init(from dict: [String: Any]) {
        self.proteins = dict[Key.proteins] as? Float ?? 0
        self.carbohydrates = dict[Key.carbohydrates] as? Float ?? 0
        self.fats = dict[Key.fats] as? Float ?? 0
        self.calories = dict[Key.calories] as? Float ?? 0
    }
    
    init(from modelMO: CustomNutritionModeMO) {
        self.proteins = modelMO.proteins
        self.fats = modelMO.fats
        self.calories = modelMO.calories
        self.carbohydrates = modelMO.carbohydrates
    }
}
