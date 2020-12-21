import Foundation

struct FoodResponseModel: Decodable {
    let foods: [Food]
}

struct Food: Decodable {
    let lowercaseDescription: String?
    let foodNutrients: [FoodNutrients]
}

struct FoodNutrients: Decodable {
    let nutrientId: Int?
    let value: Double?
}
