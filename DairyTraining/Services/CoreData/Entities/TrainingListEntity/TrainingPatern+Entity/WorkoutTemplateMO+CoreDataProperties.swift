//
//  WorkoutTemplateMO+CoreDataProperties.swift
//  Dairy Training
//
//  Created by cogniteq on 17.03.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutTemplateMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutTemplateMO> {
        return NSFetchRequest<WorkoutTemplateMO>(entityName: "WorkoutTemplate")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var exercises: NSSet?

    var exerciseArray: [ExerciseMO] {
          get {
              let exerciseSet = self.exercises as? Set<ExerciseMO> ?? []
            return exerciseSet.sorted(by: { $0.id < $1.id })
          }
          set {
              self.exercises = NSSet(array: newValue)
          }
      }
    
}

// MARK: Generated accessors for exercises
extension WorkoutTemplateMO {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseMO)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseMO)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension WorkoutTemplateMO : Identifiable {

}
