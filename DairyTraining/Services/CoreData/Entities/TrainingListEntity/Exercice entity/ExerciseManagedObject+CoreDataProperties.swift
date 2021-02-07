import UIKit
import CoreData

extension ExerciseManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseManagedObject> {
        return NSFetchRequest<ExerciseManagedObject>(entityName: "Exercice")
    }
    @NSManaged public var isDone: Bool
    @NSManaged public var name: String
    @NSManaged public var id: Int64
    @NSManaged public var subgroupName: String
    @NSManaged public var groupName: String
    @NSManaged public var date: Date?
    @NSManaged public var training: TrainingManagedObject?
    @NSManaged public var trainingPatern: TrainingPaternManagedObject?
    @NSManaged public var aproaches: NSSet
}

// MARK: Generated accessors for aproaches
extension ExerciseManagedObject {

    @objc(addAproachesObject:)
    @NSManaged public func addToAproaches(_ value: AproachManagedObject)

    @objc(removeAproachesObject:)
    @NSManaged public func removeFromAproaches(_ value: AproachManagedObject)

    @objc(addAproaches:)
    @NSManaged public func addToAproaches(_ values: NSSet)

    @objc(removeAproaches:)
    @NSManaged public func removeFromAproaches(_ values: NSSet)
}

//MARK: - Custom properties
extension ExerciseManagedObject {
    
    var totalRepsCount: Double {
        var summ: Double = 0
        aproachesArray.forEach({ aproach in
            summ += Double(aproach.reps)
        })
        return summ
    }
    
    var setsCount: Double {
        return Double(aproaches.count)
    }
    
    var sumWeightOfExercise: Double {
        var summ: Double = 0
        aproachesArray.forEach({ approach in summ += approach.summWeightOfAproach })
        return summ
    }
    
    var aproachesArray: [AproachManagedObject] {
        get {
            let aproachesSet = self.aproaches as? Set<AproachManagedObject> ?? []
            return aproachesSet.sorted(by: { $0.number < $1.number })
        }
        set {
            self.aproaches = NSSet(array: newValue)
        }
    }
    
    var subGroup: MuscleSubgroup.Subgroup? {
        return MuscleSubgroup.Subgroup.init(rawValue: self.subgroupName)
    }
    
    var image: UIImage? {
        return self.subGroup?.image
    }
}
