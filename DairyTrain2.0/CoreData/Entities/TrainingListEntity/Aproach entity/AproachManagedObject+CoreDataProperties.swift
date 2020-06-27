
import Foundation
import CoreData


extension AproachManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AproachManagedObject> {
        return NSFetchRequest<AproachManagedObject>(entityName: "Aproach")
    }

    @NSManaged public var number: Int64
    @NSManaged public var reps: Int64
    @NSManaged public var weight: Float
    @NSManaged public var exercise: ExerciseManagedObject?
    
    var weightDisplayvalue: String {
        switch MeteringSetting.shared.weightMode {
        case .kg:
            if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.weight) + " kg."
            } else {
                return String(format: "%.1f", self.weight) + " kg."
            }
        case .lbs:
            if self.weight.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", self.weight) + " lbs."
            } else {
                return String(format: "%.1f", self.weight) + " lbs."
            }
        }
    }
    
    var repsDisplayValue: String {
               return "\(self.reps) reps"
           }

}
