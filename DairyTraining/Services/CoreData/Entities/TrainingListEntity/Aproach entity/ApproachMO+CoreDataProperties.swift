//
//  ApproachMO+CoreDataProperties.swift
//  Dairy Training
//
//  Created by cogniteq on 17.03.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension ApproachMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ApproachMO> {
        return NSFetchRequest<ApproachMO>(entityName: "Approach")
    }

    @NSManaged public var index: Int64
    @NSManaged public var reps: Int64
    @NSManaged public var weightMode: String
    @NSManaged public var weightValue: Float
    @NSManaged public var exercise: ExerciseMO?

}

extension ApproachMO : Identifiable {

}

extension ApproachMO {
    
    var weight: MeasurementUnit.Weight {
        let weightMode = UserInfo.WeightMode(rawValue: self.weightMode)
        let weight = MeasurementUnit.Weight(weightValue: weightValue,
                                            weightMode: weightMode ?? UserInfo.WeightMode.defaultWeightMode)
        return weight
    }
    
    var totalWeight: Float {
        return reps.float * weight.value
    }
}
