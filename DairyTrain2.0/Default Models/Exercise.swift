import UIKit

class Exercise: NSObject, Codable {
 
    //MARK: - Structures
    struct Approach: Hashable, Codable {
        var weight: Float
        var reps: Int
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
    
    //MARK: - Properties
    var name: String
    var group: MuscleGroup.Group
    var subgroub: MuscleSubgroup.Subgroup
    var aproaches: [Approach] = []
    var isSelected: Bool = false
    
    //MARK: - Compudet properties
    var numberOfAproach: Int {
        return self.aproaches.count
    }
    var muscleGroupImage: UIImage? {
        return self.group.image
    }
    var muscleSubGroupImage: UIImage? {
        return self.subgroub.image
    }

    //MARK: - Initialization
    init(name: String, subgroup: MuscleSubgroup.Subgroup) {
        self.name = name
        self.subgroub = subgroup
        switch subgroub {
        case .frontDelts:
            self.group = .shoulders
        case .middleDelts:
            self.group = .shoulders
        case .rearDelts:
            self.group = .shoulders
        case .upperChest:
            self.group = .chest
        case .lowerChest:
            self.group = .chest
        case .middleChest:
            self.group = .chest
        case .biceps:
            self.group = .arms
        case .triceps:
            self.group = .arms
        case .frontSideHip:
            self.group = .legs
        case .backSideHip:
            self.group = .legs
        case .calves:
            self.group = .legs
        case .abs:
            self.group = .core
        case .lowBack:
            self.group = .core
        case .latissimusDorsi:
            self.group = .back
        case .trapezoid:
            self.group = .back
        }
    }
}
