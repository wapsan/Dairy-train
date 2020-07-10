import Foundation
import CoreData

extension AproachManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AproachManagedObject> {
        return NSFetchRequest<AproachManagedObject>(entityName: "Aproach")
    }
    
    @NSManaged public var weightMode: String
    @NSManaged public var number: Int64
    @NSManaged public var reps: Int64
    @NSManaged public var weight: Float
    @NSManaged public var exercise: ExerciseManagedObject?
}

//MARK: - Custom properties
extension AproachManagedObject {
    
    var weightMultiplier: Float {
        return MeteringSetting.shared.weightMultiplier
    }
    
    var weightEnumMode: MeteringSetting.WeightMode? {
        return MeteringSetting.WeightMode.init(rawValue: self.weightMode)
    }
    
    var weightDisplayvalue: String {
        guard let weightMode = self.weightEnumMode else { return "" }
        if weightMode == MeteringSetting.shared.weightMode {
            if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.weight) + MeteringSetting.shared.weightDescription
            } else {
                return String(format: "%.1f", self.weight) + MeteringSetting.shared.weightDescription
            }
        } else {
            let newWeight = self.weight * self.weightMultiplier
            if newWeight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", newWeight) + MeteringSetting.shared.weightDescription
            } else {
                return String(format: "%.1f", newWeight) + MeteringSetting.shared.weightDescription
            }
        }
    }
    
    var repsDisplayValue: String {
        return "\(self.reps) Reps"
    }
}
