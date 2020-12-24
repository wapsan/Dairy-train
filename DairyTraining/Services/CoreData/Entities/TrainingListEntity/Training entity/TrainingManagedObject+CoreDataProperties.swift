import Foundation
import CoreData

extension TrainingManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingManagedObject> {
        return NSFetchRequest<TrainingManagedObject>(entityName: "Training")
    }

    @NSManaged public var date: Date
    @NSManaged public var exercises: NSSet?
    @NSManaged public var formatedDate: String?
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

//MARK: - Custom properties
extension TrainingManagedObject {
    
    var isEditable: Bool {
        let todayDate = DateHelper.shared.getFormatedDateFrom(Date(), with: .chekingCurrentDayDateFormat)
        let trainingDay = DateHelper.shared.getFormatedDateFrom(date, with: .chekingCurrentDayDateFormat)
        return todayDate == trainingDay
    }
    
    var exercicesArray: [ExerciseManagedObject] {
        let exerciseSet = self.exercises as? Set<ExerciseManagedObject> ?? []
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
}
