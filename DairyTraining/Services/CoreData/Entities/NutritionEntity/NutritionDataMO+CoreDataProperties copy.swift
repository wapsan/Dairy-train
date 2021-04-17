//
//  NutritionDataMO+CoreDataProperties.swift
//  
//
//  Created by cogniteq on 15.12.2020.
//
//

import Foundation
import CoreData


extension NutritionDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NutritionDataMO> {
        return NSFetchRequest<NutritionDataMO>(entityName: "NutritionDataMO")
    }
    
    @NSManaged public var formatedDate: String?
    @NSManaged public var date: Date?
    @NSManaged public var meals: NSSet?

}

// MARK: Generated accessors for meals
extension NutritionDataMO {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: MealMO)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: MealMO)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension NutritionDataMO {
    
    var mealsArray: [MealMO] {
        let mealsSet = self.meals as? Set<MealMO> ?? []
        return mealsSet.sorted(by: { $0.date < $1.date })
    }
    
    static let dateFormat = "dd.MM.yyyy"
    
}
