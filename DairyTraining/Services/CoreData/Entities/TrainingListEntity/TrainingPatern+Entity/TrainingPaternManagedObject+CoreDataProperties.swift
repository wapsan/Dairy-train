import Foundation
import CoreData

extension TrainingPaternManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingPaternManagedObject> {
        return NSFetchRequest<TrainingPaternManagedObject>(entityName: "TrainingPatern")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var exercises: NSSet?
    
    
    var exerciseArray: [ExerciseManagedObject] {
          get {
              let exerciseSet = self.exercises as? Set<ExerciseManagedObject> ?? []
            return exerciseSet.sorted(by: { $0.id < $1.id })
          }
          set {
              self.exercises = NSSet(array: newValue)
          }
      }

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

