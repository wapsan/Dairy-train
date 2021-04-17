//
//  MealMO+CoreDataProperties.swift
//  
//
//  Created by cogniteq on 15.12.2020.
//
//

import Foundation
import CoreData


extension MealMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealMO> {
        return NSFetchRequest<MealMO>(entityName: "MealMO")
    }
    
    @NSManaged public var formatedDate: String?
    @NSManaged public var hour: Int32
    @NSManaged public var date: Date
    @NSManaged public var calories: Float
    @NSManaged public var proteins: Float
    @NSManaged public var name: String?
    @NSManaged public var weight: Float
    @NSManaged public var carbohydrates: Float
    @NSManaged public var fats: Float
    @NSManaged public var nutritionData: NutritionDataMO?

}

extension MealMO: FoodPresentable {
    
    static let dateFormat = "dd.MM.yyyy"
    
    var foodWeight: String? {
        return String(format: "%.02fg", weight)
    }
    
    var foodName: String? {
        return name?.capitalized
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
