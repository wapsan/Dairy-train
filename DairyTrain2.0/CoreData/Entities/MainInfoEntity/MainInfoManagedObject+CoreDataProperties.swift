import Foundation
import CoreData

extension MainInfoManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainInfoManagedObject> {
        return NSFetchRequest<MainInfoManagedObject>(entityName: "MainInfo")
    }

    @NSManaged public var activitylevel: String?
    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var height: Float
    @NSManaged public var heightMode: String?
    @NSManaged public var weight: Float
    @NSManaged public var weightMode: String?
}
