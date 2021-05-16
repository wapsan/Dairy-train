//
//  WorkoutMO+CoreDataProperties.swift
//  Dairy Training
//
//  Created by cogniteq on 17.03.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutMO> {
        return NSFetchRequest<WorkoutMO>(entityName: "Workout")
    }

    @NSManaged public var date: Date
    @NSManaged public var startTimeDate: Date?
    @NSManaged public var formatedDate: String?
    @NSManaged public var endTimeDate: Date?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension WorkoutMO {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseMO)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseMO)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension WorkoutMO : Identifiable {

}


extension WorkoutMO {
    
    var duration: Int {
        guard let startTime = startTimeDate, let endTime = endTimeDate else { return 0 }
        let duration = endTime.timeIntervalSince(startTime)
        let durationDate = Date(timeIntervalSince1970: duration)
        return Calendar.current.component(.minute, from: durationDate)
    }
    
    var totalRepsCount: Int {
        var summ: Int = 0
        exercicesArray.forEach({ exercise in summ += exercise.totalRepsCount })
        return summ
    }
    
    var setsCount: Double {
        var summ: Double = 0
        exercicesArray.forEach({ exercise in summ += exercise.setsCount })
        return summ
    }
    
    var sumWeightOfTraining: Float {
        var summ: Float = 0
        exercicesArray.forEach({ exercise in
            summ += exercise.sumWeightOfExercise
        })
        return summ
    }
    
    var isEditable: Bool {
        let todayDate = DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat)
        let trainingDay = DateHelper.shared.getFormatedDateFrom(date, with: .chekingCurrentDayDateFormat)
        return todayDate == trainingDay
    }
    
    var exercicesArray: [ExerciseMO] {
        let exerciseSet = self.exercises as? Set<ExerciseMO> ?? []
        return exerciseSet.sorted(by: { $0.id < $1.id })
    }
    
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
            if let subGroup = MuscleSubgroup.Subgroup.init(rawValue: exercice.subgroupName) {
                if subGroupSet.insert(subGroup).inserted {
                    subGroupArray.append(subGroup)
                }
            }
        }
        return subGroupArray
    }
    
    func getExercise() -> [ExerciseMO] {
        return exercicesArray.sorted(by: { $0.id < $1.id })
    }
    
}
