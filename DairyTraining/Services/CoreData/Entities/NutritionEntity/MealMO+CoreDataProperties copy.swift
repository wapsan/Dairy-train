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

    @NSManaged public var calories: Float
    @NSManaged public var proteins: Float
    @NSManaged public var name: String?
    @NSManaged public var weight: Float
    @NSManaged public var carbohydrates: Float
    @NSManaged public var fats: Float
    @NSManaged public var nutritionData: NutritionDataMO?

}
