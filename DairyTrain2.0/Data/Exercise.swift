import UIKit



class Exercise {
 
    //MARK: - Structures
    struct Approach: Hashable {
        var weight: Double
        var reps: Int
        var numberOfAproach: Int
        var weightDisplayvalue: String {
            switch MeteringSetting.shared.weightMode {
            case .kg:
                return ""
            case .lbs:
                return ""
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
    var numerOfAproach: Int {
        return self.aproaches.count
    }
    var muscleGroupImage: UIImage? {
        return self.group.image
    }
    var muscleSubGroupImage: UIImage? {
        return self.subgroub.image
    }
    
    //MARK: - Publick methods
    func addAproachWith(_ reps: Int, and weight: Double, and aproachNumber: Int) {
        var aproachesSet = Set<Approach>()
        let aproach = Approach(weight: weight, reps: reps, numberOfAproach: aproachNumber )
        if aproachesSet.insert(aproach).inserted {
            self.aproaches.append(aproach)
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


