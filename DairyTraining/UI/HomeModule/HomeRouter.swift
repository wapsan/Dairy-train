import UIKit

protocol HomeRouterProtocol {
    func showSideMenu()
    
    func showExerciseFlow()
    func showWorkoutsPaternFlow()
    func showReadyWorkoutsFlow()
    func showSearchFoodFlow()
    func showMonthlyStatisticsScreen()
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
        let monthlyStatisticViewController = MonthlyStatisticsConfigurator.configureScreen()
        roorViewController.navigationController?.pushViewController(monthlyStatisticViewController,
                                                                    animated: true)
    }
}

// MARK: - HomeRouterProtocol
extension HomeRouter: HomeRouterProtocol {
   
    func showSideMenu() {
        let sideMenu = SideMenuConfigurator().configure(with: self)
        mainTabBar?.present(sideMenu, animated: true, completion: nil)
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
