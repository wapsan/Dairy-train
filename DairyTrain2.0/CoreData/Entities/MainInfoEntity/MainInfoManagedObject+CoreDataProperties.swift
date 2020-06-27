import Foundation
import CoreData

extension MainInfoManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainInfoManagedObject> {
        return NSFetchRequest<MainInfoManagedObject>(entityName: "MainInfo")
    }

    @NSManaged public var age: Int64
    @NSManaged public var weight: Float
    @NSManaged public var height: Float
    @NSManaged public var gender: String?
    @NSManaged public var activitylevel: String?
    @NSManaged public var heightMode: String?
    @NSManaged public var weightMode: String?
    @NSManaged public var id: Int64
    
    var displayAge: String {
        return String(age)
    }
    
    var displayHeight: String {
        if self.height.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self.height)
        } else {
            return String(format: "%.1f", self.height)
        }
    }
    
    var displayWeight: String {
        if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self.weight)
        } else {
            return String(format: "%.1f", self.weight)
        }
    }
    
    var displayGender: String {
        return self.gender ?? "_"
    }
    
    var displayActivityLevel: String {
        return self.activitylevel ?? "_"
    }
}
