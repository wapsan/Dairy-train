//
//  ExerciseMO+CoreDataProperties.swift
//  Dairy Training
//
//  Created by cogniteq on 17.03.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension ExerciseMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseMO> {
        return NSFetchRequest<ExerciseMO>(entityName: "Exercise")
    }

    @NSManaged public var name: String
    @NSManaged public var date: Date
    @NSManaged public var groupName: String
    @NSManaged public var id: Int64
    @NSManaged public var isDone: Bool
    @NSManaged public var subgroupName: String
    @NSManaged public var approaches: NSSet?
    @NSManaged public var workout: WorkoutMO
    @NSManaged public var workoutTemplate: WorkoutTemplateMO?

}

// MARK: Generated accessors for approaches
extension ExerciseMO {

    @objc(addApproachesObject:)
    @NSManaged public func addToApproaches(_ value: ApproachMO)

    @objc(removeApproachesObject:)
    @NSManaged public func removeFromApproaches(_ value: ApproachMO)

    @objc(addApproaches:)
    @NSManaged public func addToApproaches(_ values: NSSet)

    @objc(removeApproaches:)
    @NSManaged public func removeFromApproaches(_ values: NSSet)

}

extension ExerciseMO : Identifiable {

}

extension ExerciseMO {
    
    var totalRepsCount: Int {
        var summ: Int = 0
        aproachesArray.forEach({ aproach in
            summ += aproach.reps.int
        })
        return summ
    }
    
    var setsCount: Double {
        return Double(aproachesArray.count)
    }
    
    var sumWeightOfExercise: Float {
        var summ: Float = 0
        aproachesArray.forEach({ approach in summ += approach.totalWeight })
        return summ
    }
    
    var aproachesArray: [ApproachMO] {
        get {
            let aproachesSet = self.approaches as? Set<ApproachMO> ?? []
            return aproachesSet.sorted(by: { $0.index < $1.index })
        }
        set {
            self.approaches = NSSet(array: newValue)
        }
    }
    
    var subGroup: MuscleSubgroup.Subgroup? {
        return MuscleSubgroup.Subgroup.init(rawValue: subgroupName)
    }

}
