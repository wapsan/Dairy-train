//
//  TrainingPaternManagedObject+CoreDataProperties.swift
//  Dairy Training
//
//  Created by Вячеслав on 27.09.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension TrainingPaternManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingPaternManagedObject> {
        return NSFetchRequest<TrainingPaternManagedObject>(entityName: "TrainingPatern")
    }

    @NSManaged public var name: String
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension TrainingPaternManagedObject {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseManagedObject)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseManagedObject)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}
