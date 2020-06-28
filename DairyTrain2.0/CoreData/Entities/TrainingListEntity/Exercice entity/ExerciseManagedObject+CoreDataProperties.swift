import UIKit
import CoreData


extension ExerciseManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseManagedObject> {
        return NSFetchRequest<ExerciseManagedObject>(entityName: "Exercice")
    }

    @NSManaged public var name: String
    @NSManaged public var id: Int64
    @NSManaged public var subgroupName: String
    @NSManaged public var groupName: String
    @NSManaged public var training: TrainingManagedObject?
    @NSManaged public var aproaches: NSSet
    
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
