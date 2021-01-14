import UIKit

protocol HomeModelProtocol {
    var menuItems: [HomeModel.MenuItem] { get }
    
    func getMenuItemForIndex(index: Int) -> HomeModel.MenuItem
    func callMenuItemAction(for index: Int)
    func showSideMenu()
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
        
        func onAction() {
            switch self {
            case .createTrainingFromExerciseList:
                MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .training))
            case .createTrainingFromTrainingPatern:
                MainCoordinator.shared.coordinate(to: TrainingPaternsCoordinator.Target.trainingPaternsList)
            case .createTrainingFromSpecialTraining:
                MainCoordinator.shared.coordinate(to: TrainingProgramsCoordinator.Target.trainingLevels)
            case .addMeal:
                MainCoordinator.shared.coordinate(to: NutritionModuleCoordinator.Target.searchFood)
            case .mounthlyStatistics:
                return
            }
        }
    }
    
}

// MARK: - HomeModelProtocol
extension HomeModel: HomeModelProtocol {
    
    func showSideMenu() {
        MainCoordinator.shared.coordinate(to: HomeCoordinator.Target.sideMenu)
    }
    
    var menuItems: [MenuItem] {
        return MenuItem.allCases
    }
    
    func getMenuItemForIndex(index: Int) -> MenuItem {
        return menuItems[index]
    }
    
    func callMenuItemAction(for index: Int) {
        menuItems[index].onAction()
    }
}
