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
        guard let heightMode = MeteringSetting.HeightMode.init(rawValue: self.heightMode ?? "") else { return "" }
        if heightMode == MeteringSetting.shared.heightMode {
            if self.height.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.height)
            } else {
                return String(format: "%.1f", self.height)
            }
        } else {
            if self.height.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.height * MeteringSetting.shared.heightMultiplier)
            } else {
                return String(format: "%.1f", self.height * MeteringSetting.shared.heightMultiplier)
            }
        }
    }
    
    var displayWeight: String {
        guard let weightMode = MeteringSetting.WeightMode.init(rawValue: self.weightMode ?? "") else { return "" }
        if weightMode == MeteringSetting.shared.weightMode {
            if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.weight)
            } else {
                return String(format: "%.1f", self.weight)
            }
        } else {
            if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.weight * MeteringSetting.shared.weightMultiplier)
            } else {
                return String(format: "%.1f", self.weight * MeteringSetting.shared.weightMultiplier)
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
