import UIKit

protocol CreatingTrainingModalModelProtocol {
    
}

final class CreatingTrainingModalModel {
    
    enum Option: String, CaseIterable {
        case fromExerciseList = "Exercise"
        case fromTrainingPatern = "Paterns"
        case fromSpecialTraining = "Special training"
        
        var title: String {
            return self.rawValue
        }
        
        var image: UIImage? {
            switch self {
            case .fromExerciseList:
                return UIImage(named: "avareProjectileWeightBackground")
            case .fromTrainingPatern:
                return UIImage(named: "avareProjectileWeightBackground")
            case .fromSpecialTraining:
                return UIImage(named: "avareProjectileWeightBackground")
            }
        }
    }
}

extension CreatingTrainingModalModel: CreatingTrainingModalModelProtocol {
  
    
    
}
