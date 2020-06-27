//
//  TrainingManagedObject+CoreDataProperties.swift
//  DairyTrain2.0
//
//  Created by Вячеслав on 26.06.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension TrainingManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingManagedObject> {
        return NSFetchRequest<TrainingManagedObject>(entityName: "Training")
    }

    @NSManaged public var date: Date?
    @NSManaged public var exercises: NSSet?
    @NSManaged public var formatedDate: String?
    
    var exercicesArray: [ExerciseManagedObject] {
          let exerciseSet = self.exercises as? Set<ExerciseManagedObject> ?? []
          return exerciseSet.sorted(by: { $0.id < $1.id })
      }
    
    
      
//     lazy var formatedDate: String {
//        guard let date = self.date else { return "0" }
//        let formatedDate = DateHelper.shared.getFormatedDateFrom(date)
//        return formatedDate
//      }
      
      var muscleGroupInCurrentTrain: [MuscleGroup.Group] {
          var groupSet = Set<MuscleGroup.Group>()
          var groupArray: [MuscleGroup.Group] = []
          for exercice in self.exercicesArray {
              if let group = MuscleGroup.Group.init(rawValue: exercice.groupName) {
                  if groupSet.insert(group).inserted {
                      groupArray.append(group)
                  }
              }
          }
          return groupArray
      }
      
      var muscleSubgroupInCurentTraint: [MuscleSubgroup.Subgroup] {
          var subGroupSet = Set<MuscleSubgroup.Subgroup>()
          var subGroupArray: [MuscleSubgroup.Subgroup] = []
          for exercice in self.exercicesArray {
              if let subGroup = MuscleSubgroup.Subgroup.init(rawValue: exercice.groupName) {
                  if subGroupSet.insert(subGroup).inserted {
                      subGroupArray.append(subGroup)
                  }
              }
          }
          return subGroupArray
      }

}

// MARK: Generated accessors for exercises
extension TrainingManagedObject {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseManagedObject)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseManagedObject)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}
