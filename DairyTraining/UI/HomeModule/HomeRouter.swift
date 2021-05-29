import UIKit

protocol CreationExerciseFlowProtocol {
    func showExerciseFlow()
    func showWorkoutsPaternFlow()
    func showReadyWorkoutsFlow()
}

protocol HomeRouterProtocol: CreationExerciseFlowProtocol {
    func showSideMenu()
    func showSearchFoodFlow()
    func showMonthlyStatisticsScreen()
}

final class HomeRouter: BaseRouter { }

// MARK: - HomeRouterProtocol
extension HomeRouter: HomeRouterProtocol {
    
    func showSearchFoodFlow() {
        let searchFoodViewController = SearchFoodConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: searchFoodViewController)
        navigationController.modalPresentationStyle = .fullScreen
        tabBarController?.present(navigationController, animated: true, completion: nil)
    }
    
    func showSideMenu() {
        let sideMenu = SideMenuConfigurator().configure(with: self)
        tabBarController?.present(sideMenu, animated: true, completion: nil)
    }
    
    func showMonthlyStatisticsScreen() {
        let monthlyStatisticViewController = MonthlyStatisticsConfigurator.configureScreen()
        pushViewController(monthlyStatisticViewController, animated: true)
    }
}

//MARK: - SideMenuRouterDelegate
extension HomeRouter: SideMenuRouterDelegate {
    
    func pushSettingScreen() {
        let settingViewController = SettingsSectionViewController(with: LocalizedString.setting)
        pushViewController(settingViewController, animated: true)
    }
    
    func pushTermsAndConditionScreen() {
        return
    }
}

// MARK: - CreationExerciseFlowProtocol
extension HomeRouter {
    
    func showExerciseFlow() {
        let muscleGroupViewController = MuscleGroupsViewControllerConfigurator().configure(for: .training)
        let navigationController = UINavigationController(rootViewController: muscleGroupViewController)
        navigationController.modalPresentationStyle = .fullScreen
        tabBarController?.present(navigationController, animated: true, completion: nil)
    }
    
    func showWorkoutsPaternFlow() {
        let trainingPaternViewController = TrainingPaternsViewControllerConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: trainingPaternViewController)
        navigationController.modalPresentationStyle = .fullScreen
        tabBarController?.present(navigationController, animated: true, completion: nil)
    }

    func showReadyWorkoutsFlow() {
        let trainingLevelsScreen = TrainingProgramsLevelsConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: trainingLevelsScreen)
        navigationController.modalPresentationStyle = .fullScreen
        tabBarController?.present(navigationController, animated: true, completion: nil)
    }
}
