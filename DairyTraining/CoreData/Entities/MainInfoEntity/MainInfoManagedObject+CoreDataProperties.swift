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
    @NSManaged public var dateOfLastUpdate: String?
    
    var isSet: Bool {
        if self.age == 0 {
            return false
        }
        if self.weight == 0 {
            return false
        }
        if self.height == 0 {
            return false
        }
        if self.gender == nil {
            return false
        }
        if self.activitylevel == nil {
            return false
        }
        return true
    }
    
    var displayAge: String {
        return String(age)
    }
    
    var displayDateOfLastUpdate: String {
        if let lastUpdateDate = self.dateOfLastUpdate {
            return lastUpdateDate
        } else {
            return "Date don't update."
        }
    }
    
    var displayHeight: String {
        guard let heightMode = MeteringSetting.HeightMode.init(rawValue: self.heightMode ?? "0") else { return "0" }
        if heightMode == MeteringSetting.shared.heightMode {
            if self.height.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.height)
            } else {
                return String(format: "%.1f", self.height)
            }
        } else {
            
            let newHeigt = self.height * MeteringSetting.shared.heightMultiplier
            if newHeigt.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", newHeigt)
            } else {
                return String(format: "%.1f", newHeigt)
            }
        }
    }
    
    var displayWeight: String {
        guard let weightMode = MeteringSetting.WeightMode.init(rawValue: self.weightMode ?? "0") else { return "0" }
        if weightMode == MeteringSetting.shared.weightMode {
            if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.weight)
            } else {
                return String(format: "%.1f", self.weight)
            }
        } else {
            let newWeight = self.weight * MeteringSetting.shared.weightMultiplier
            if newWeight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", newWeight)
            } else {
                return String(format: "%.1f", newWeight)
            }
        }
    }
    
    var displayGender: String {
        return self.gender ?? "_"
    }
    
    var displayActivityLevel: String {
        return self.activitylevel ?? "_"
    }
}
