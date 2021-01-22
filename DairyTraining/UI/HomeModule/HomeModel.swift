import UIKit
import Firebase

protocol HomeModelProtocol {
    var menuItems: [HomeModel.MenuItem] { get }
    
    func getMenuItemForIndex(index: Int) -> HomeModel.MenuItem
}

final class HomeModel {
    
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

// MARK: - HomeModelProtocol
extension HomeModel: HomeModelProtocol {
    
    var menuItems: [MenuItem] {
        return MenuItem.allCases
    }
    
    func getMenuItemForIndex(index: Int) -> MenuItem {
        return menuItems[index]
    }
}
