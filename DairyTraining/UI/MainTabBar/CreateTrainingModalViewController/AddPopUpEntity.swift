import UIKit

extension AddPopUpInteractor {
    
    //MARK: - Types
    enum AddingOptionType {
        case trainingEntity
        case mealEntity
        
        var title: String {
            switch self {
            case .trainingEntity:
                return "Create training with following options"
            case .mealEntity:
                return "Add meals with options"
            }
        }
    }
    
    enum Option: String, CaseIterable {
        case fromExerciseList = "Exercise"
        case fromTrainingPatern = "Paterns"
        case fromSpecialTraining = "Special training"
        
        case searchFood = "Search food"
        case customFood = "Add calories manualy"
        
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
            case .searchFood:
                return UIImage(named: "avareProjectileWeightBackground")
            case .customFood:
                return UIImage(named: "avareProjectileWeightBackground")
            }
        }
    }
}
