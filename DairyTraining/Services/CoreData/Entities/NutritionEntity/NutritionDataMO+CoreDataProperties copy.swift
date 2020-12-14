//
//  NutritionDataMO+CoreDataProperties.swift
//  
//
//  Created by cogniteq on 14.12.2020.
//
//

import Foundation
import CoreData


extension NutritionDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NutritionDataMO> {
        return NSFetchRequest<NutritionDataMO>(entityName: "NutritionDataMO")
    }

    @NSManaged public var date: Date?
    @NSManaged public var calories: Float
    @NSManaged public var proteins: Float
    @NSManaged public var catbohidrates: Float
    @NSManaged public var fats: Float

}
