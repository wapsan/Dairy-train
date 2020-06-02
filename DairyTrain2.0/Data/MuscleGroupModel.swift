import UIKit



class MuscleGroup {
    
    enum Group: String {
        case shoulders = "Shoulders"
        case chest = "Chest"
        case arms = "Arms"
        case back = "Back"
        case core = "Core"
        case legs = "Legs"
        
        var image: UIImage? {
            switch self {
            case .shoulders:
                return UIImage.shouldersImage
            case .chest:
                return UIImage.chestImage
            case .arms:
                return UIImage.armsImage
            case .back:
                return UIImage.backImage
            case .core:
                return UIImage.coreImage
            case .legs:
                return UIImage.legsImage
            }
        }
    }
    
    var groups: [MuscleGroup.Group] = []
    
    init() {
        self.groups = [.shoulders, .arms, .chest, .back, .core, .legs]
    }
    
}



