//
//  MealModel.swift
//  Dairy Training
//
//  Created by cogniteq on 15.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import Foundation

struct MealResponseModel {
    
    let mealName: String
    let weight: Float
    let calories: Float
    let proteins: Float
    let carbohydrates: Float
    let fats: Float
}

extension MealResponseModel: FoodPresentable {
    
    var foodWeight: String? {
        return String(format: "%.02fg", weight)
    }
    
    var foodName: String? {
        return mealName.capitalized
    }
    
    var kkal: String {
        return String(format: "Kkal: %.02f", calories).capitalized
    }
    
    var displayProteins: String {
        return String(format: "Proteins: %.02f", proteins).capitalized
    }
    
    var displayCarbohydrate: String {
        return String(format: "Carbohydrates: %.02f", carbohydrates).capitalized
    }
    
    var displayFat: String {
        return String(format: "Fats: %.02f", fats).capitalized
    }
}
