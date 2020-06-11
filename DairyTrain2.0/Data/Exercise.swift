import UIKit

class Exercise {
 
    //MARK: - Structures
    struct Approach: Hashable {
        var weight: Double
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
    
    //MARK: - Publick methods
    func addAproachWith(_ reps: Int, and weight: Double) {
        var aproachesSet = Set<Approach>()
        let aproach = Approach(weight: weight, reps: reps)
        if aproachesSet.insert(aproach).inserted {
            self.aproaches.append(aproach)
        }
    }
    
    func changeAproach(_ aproachIndex: Int, with reps: Int, and weight: Double) {
        if reps == 0 || weight == 0 {
            self.aproaches.remove(at: aproachIndex)
        } else {
            var aproach = self.aproaches[aproachIndex]
            aproach.weight = weight
            aproach.reps = reps
            self.aproaches.remove(at: aproachIndex)
            self.aproaches.insert(aproach, at: aproachIndex)
        }
    }
    
    func removeAproach() {
        self.aproaches.removeLast()
    }
    
    func removeAproachAt(_ index: Int) {
        self.aproaches.remove(at: index)
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


