import UIKit

struct Exercise {

    //MARK: - Properties
    private var _name: String
    
    //MARK: - Public properties
    var group: MuscleGroup.Group
    var subgroub: MuscleSubgroup.Subgroup
    
    //MARK: - Initialization
    init(name: String, subgroup: MuscleSubgroup.Subgroup) {
        self._name = name
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

//MARK: - Groupable
extension Exercise: Groupable  {
    
    var name: String {
        return self._name
    }
    
    var image: UIImage? {
        return self.subgroub.image
    }
}

//MARK: - Equatable
extension Exercise: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
