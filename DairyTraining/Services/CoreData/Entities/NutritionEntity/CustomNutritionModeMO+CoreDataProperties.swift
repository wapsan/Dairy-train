//
//  CustomNutritionModeMO+CoreDataProperties.swift
//  Dairy Training
//
//  Created by cogniteq on 18.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension CustomNutritionModeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomNutritionModeMO> {
        return NSFetchRequest<CustomNutritionModeMO>(entityName: "CustomNutritionModeMO")
    }

    @NSManaged public var calories: Float
    @NSManaged public var proteins: Float
    @NSManaged public var carbohydrates: Float
    @NSManaged public var fats: Float

}

extension CustomNutritionModeMO : Identifiable {

}
