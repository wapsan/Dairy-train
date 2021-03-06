import UIKit

struct Exercise {

    //MARK: - Properties
    var name: String
    var group: MuscleGroup.Group
    var subgroub: MuscleSubgroup.Subgroup
    var isSelected: Bool = false
    
    //MARK: - Compudet properties
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
