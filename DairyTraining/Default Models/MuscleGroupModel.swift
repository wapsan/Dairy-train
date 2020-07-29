import UIKit

struct MuscleGroup: Codable {
    
    enum Group: String, Codable, CaseIterable, Groupable {
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
        
        var name: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }

    }
    
    var groups: [MuscleGroup.Group] = []

    init() {
        self.groups = [.shoulders, .arms, .chest, .back, .core, .legs]
    }
}
