import UIKit

protocol Groupable {
    var image: UIImage? { get }
    var name: String { get }
    var promptDescription: String? { get }
}

extension Groupable {
    var promptDescription: String? {
        return nil
    }
}

struct MuscleSubgroup: Codable {
    
    //MARK: - Enumeration
    enum Subgroup: String, Codable, Groupable {
        case frontDelts = "Front delts"
        case middleDelts = "Middle delts"
        case rearDelts = "Rear delts"
        
        case upperChest = "Upper chest"
        case middleChest = "Middle chest"
        case lowerChest = "Lower chest"
        
        case biceps = "Biceps"
        case triceps = "Triceps"
        
        case frontSideHip = "Front side hip"
        case backSideHip = "Back side hip"
        case calves = "Calves"
        
        case abs = "ABS"
        case lowBack = "Low back"
        
        case latissimusDorsi = "Latissimus dorsi"
        case trapezoid = "Trapezius"
        
        //MARK: - Properties
        var name: String {
            return self.rawValue
        }
        
        var image: UIImage? {
            switch self {
            case .frontDelts:
                return UIImage.frontDeltoidImage
            case .middleDelts:
                return UIImage.midDeltoidImage
            case .rearDelts:
                return UIImage.backDeltoidImage
            case .upperChest:
                return UIImage.upperChestImage
            case .lowerChest:
                return UIImage.lowerChestImage
            case .biceps:
                return UIImage.bicepsImage
            case .triceps:
                return UIImage.tricepsImage
            case .frontSideHip:
                return UIImage.frontSideLegsImage
            case .backSideHip:
                return UIImage.backSideLegsImage
            case .abs:
                return UIImage.absImage
            case .lowBack:
                return UIImage.lowBackCoreImage
            case .latissimusDorsi:
                return UIImage.wingsImage
            case .trapezoid:
                return UIImage.trapezoidImage
            case .calves:
                return UIImage.calvesImage
            case .middleChest:
                return UIImage.middleChestImage
            }
        }
    }
 
    var listOfSubgroups: [MuscleSubgroup.Subgroup] 
    
    //MARK: - Initialization
    init(for muscleGroup: MuscleGroup.Group) {
        switch muscleGroup {
        case .shoulders:
            self.listOfSubgroups = [MuscleSubgroup.Subgroup.frontDelts,
                                    MuscleSubgroup.Subgroup.middleDelts,
                                    MuscleSubgroup.Subgroup.rearDelts]
        case .chest:
            self.listOfSubgroups = [MuscleSubgroup.Subgroup.upperChest,
                                    MuscleSubgroup.Subgroup.middleChest,
                                    MuscleSubgroup.Subgroup.lowerChest]
        case .arms:
            self.listOfSubgroups = [MuscleSubgroup.Subgroup.biceps,
                                    MuscleSubgroup.Subgroup.triceps]
        case .back:
            self.listOfSubgroups = [MuscleSubgroup.Subgroup.latissimusDorsi,
                                    MuscleSubgroup.Subgroup.trapezoid]
        case .core:
            self.listOfSubgroups = [MuscleSubgroup.Subgroup.lowBack,
                                    MuscleSubgroup.Subgroup.abs]
        case .legs:
            self.listOfSubgroups = [MuscleSubgroup.Subgroup.frontSideHip,
                                    MuscleSubgroup.Subgroup.backSideHip,
                                    MuscleSubgroup.Subgroup.calves]
        }
    }
}
