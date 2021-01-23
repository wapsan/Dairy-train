import UIKit

protocol HomeRouterProtocol {
    func showScreen(for menuItem: HomeModel.MenuItem)
    func showSideMenu()
}

final class HomeRouter: Router {
    
    // MARK: - Properties
    private let roorViewController: UIViewController
    
    
    // MARK: - Initialization
    init(_ viewController: UIViewController) {
        self.roorViewController = viewController
    }
    
    // MARK: - Private methods
    func showMonthlyStatisticsScreen() {
        //FIX ME: Later
    }
}

// MARK: - HomeRouterProtocol
extension HomeRouter: HomeRouterProtocol {
    
    func showSideMenu() {
        let sideMenu = SideMenuConfigurator().configure(with: self)
        mainTabBar?.present(sideMenu, animated: true, completion: nil)
    }
    
    func showScreen(for menuItem: HomeModel.MenuItem) {
        switch menuItem {
        case .createTrainingFromExerciseList:
            showExerciseFlow()
            
        case .createTrainingFromTrainingPatern:
            showPaternFlow()
            
        case .createTrainingFromSpecialTraining:
            showReadyWorkoutsFlow()
            
        case .addMeal:
            showSearchFoodFlow()
            
        case .mounthlyStatistics:
            showMonthlyStatisticsScreen()
            
        }
    }
}

extension HomeRouter: SideMenuRouterDelegate {
    
    func pushSettingScreen() {
        let settingViewController = SettingsSectionViewController(with: LocalizedString.setting)
        roorViewController.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    func pushTermsAndConditionScreen() {
        return
    }
}
