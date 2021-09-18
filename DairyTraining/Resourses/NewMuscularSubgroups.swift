import Foundation
import UIKit

enum MuscularSubgroup2: String, CaseIterable, Codable {
    case frontDelts
    case middleDelts
    case rearDelts
    
    case upperChest
    case middleChest
    case lowerChest
    
    case biceps
    case triceps
    
    case frontSideHip
    case backSideHip
    case calves
    
    case abs
    case lowBack
    
    case latissimusDorsi
    case trapezoid
    
    var path: String {
        rawValue.capitalizingFirstLetter() + "ExerciseList" + (Locale.current.languageCode ?? "").uppercased()
    }
}

extension MuscularSubgroup2: PresentableEntity {
    
    var name: String {
        switch self {
        
        case .frontDelts:
            return "Front Delts"
        case .middleDelts:
            return "Middle Delts"
        case .rearDelts:
            return "Rear Delts"
        case .upperChest:
            return "Upper Chest"
        case .middleChest:
            return "Middle Chest"
        case .lowerChest:
            return "Lower Chest"
        case .biceps:
            return "Biceps"
        case .triceps:
            return "Triceps"
        case .frontSideHip:
            return "Front Side Hip"
        case .backSideHip:
            return "Back Side Hip"
        case .calves:
            return "Calves"
        case .abs:
            return "ABS"
        case .lowBack:
            return "Low Back"
        case .latissimusDorsi:
            return "Latissimus Dorsi"
        case .trapezoid:
            return "Ttrapezoid"
        }
    }
    
    var image: UIImage {
        return UIImage()
    }
    
    
}
