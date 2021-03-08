import UIKit

extension HomeInteractor {
    
    // MARK: - Types
    enum MenuItem: CaseIterable {
        case createTrainingFromExerciseList
        case createTrainingFromTrainingPatern
        case createTrainingFromSpecialTraining
        case addMeal
        case mounthlyStatistics
        
        var titel: String {
            switch self {
            case .createTrainingFromExerciseList:
                return "Create training from exiting exercises."
            case .createTrainingFromTrainingPatern:
                return "Cretate training from training patern."
            case .createTrainingFromSpecialTraining:
                return "Create training from sepcial training list challenge."
            case .addMeal:
                return "Add meal to you daily nutrition list."
            case .mounthlyStatistics:
                return "Monthly statistics."
            }
        }
        
        var image: UIImage? {
            switch self {
            case .createTrainingFromExerciseList:
                return nil
            case .createTrainingFromTrainingPatern:
                return nil
            case .createTrainingFromSpecialTraining:
                return nil
            case .addMeal:
                return nil
            case .mounthlyStatistics:
                return nil
            }
        }
    }
}
