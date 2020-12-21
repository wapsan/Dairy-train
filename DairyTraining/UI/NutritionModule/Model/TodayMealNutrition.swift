//
//  TodayMealNutrition.swift
//  Dairy Training
//
//  Created by cogniteq on 15.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import Foundation

enum TodayMealNutritionModel: String, CaseIterable {
    case mainCell
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    
    var meals: [MealModel] {
        switch self {
        case .breakfast:
            return NutritionDataManager.shared.getMealsForBreakfast()
        case .lunch:
            return NutritionDataManager.shared.getMealForLunsh()
        case .dinner:
            return NutritionDataManager.shared.getMealForDinner()
        case .mainCell:
            return []
        }
    }
}
