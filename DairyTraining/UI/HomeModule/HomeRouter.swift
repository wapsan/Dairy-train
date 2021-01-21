import UIKit

protocol HomeRouterProtocol {
    func showScreen(for menuItem: HomeModel.MenuItem)
}

final class HomeRouter: Router {
    
    // MARK: - Properties
    private let roorViewController: UIViewController
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.roorViewController = viewController
    }
    
    // MARK: - Private methods
    func showCreateWorkoutFromExerciseScreen() {
        let muscleGroupViewController = MuscleGroupsViewControllerConfigurator().configure(for: .training)
        let navigationController = UINavigationController(rootViewController: muscleGroupViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showCreateWorkoutFromTrainingPaternScreen() {
        let trainingPaternViewController = TrainingPaternsViewControllerConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: trainingPaternViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showCreateWorkoutFromCloudDataBaseScreen() {
        let trainingLevelsScreen = TrainingProgramsLevelsConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: trainingLevelsScreen)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showAddMealScreen() {
        let searchFoodViewController = SearchFoodConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: searchFoodViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showMonthlyStatisticsScreen() {
        //FIX ME: Later
    }
}

// MARK: - HomeRouterProtocol
extension HomeRouter: HomeRouterProtocol {
    
    func showScreen(for menuItem: HomeModel.MenuItem) {
        switch menuItem {
        case .createTrainingFromExerciseList:
            showCreateWorkoutFromExerciseScreen()
            
        case .createTrainingFromTrainingPatern:
            showCreateWorkoutFromTrainingPaternScreen()
            
        case .createTrainingFromSpecialTraining:
            showCreateWorkoutFromCloudDataBaseScreen()
            
        case .addMeal:
            showAddMealScreen()
            
        case .mounthlyStatistics:
            showMonthlyStatisticsScreen()
        }
    }
}
