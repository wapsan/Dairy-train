
struct NutritionResponseModel: Decodable {
    let hints: [Hints]
}

struct Hints: Decodable {
    let food: Food
}

struct Food: Decodable {
    let label: String
    let nutrients: Nutrients
}

struct Nutrients: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case proteins = "PROCNT"
        case fat = "FAT"
        case carbohydrates = "CHOCDF"
        case kkal = "ENERC_KCAL"
    }
    
    let proteins: Float?
    let fat: Float?
    let carbohydrates: Float?
    let kkal: Float?
}
