import UIKit
import SideMenu

final class ProfileMenuCoordinator: Coordinator {

    //MARK: - Constants
    private struct Constants {
        static let sideMenuWidth = UIScreen.main.bounds.width * 0.7
    }
    
    // MARK: - Types
    enum Target: CoordinatorTarget {
        case sideMenu
        case recomendation
        case statisticsModule
        case statisticsByTraining
        case statisticForChoosenTraining(statistics: Statistics)
        case setting
        case signOut(completion: (() -> Void)?)
    }
    
    // MARK: - Properties
    var window: UIWindow?
    private var navigationController: UINavigationController?
    private var sideMenu: SideMenuNavigationController?
    
    // MARK: - Init

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        case .sideMenu:
            let sideMenu = self.configurateSideMenu()
            self.sideMenu = sideMenu
            topViewController?.present(sideMenu, animated: true, completion: nil)
        case .recomendation:
            let recomendationViewController = configureRecomendationViewController()
            navigationController?.pushViewController(recomendationViewController, animated: true)
            sideMenu?.dismiss(animated: true, completion: nil)
        case .statisticsByTraining:
            let trainingListStatistics = configureTrainingListStatistics()
            navigationController?.pushViewController(trainingListStatistics, animated: true)
         //   sideMenu?.dismiss(animated: true, completion: nil)
            break
        case .setting:
            let settingViewController = SettingsSectionViewController(with: LocalizedString.setting)
            navigationController?.pushViewController(settingViewController, animated: true)
            sideMenu?.dismiss(animated: true, completion: nil)
        case .signOut(let completion):
            topViewController?.showDefaultAlert(title: LocalizedString.signOut,
                                               message: LocalizedString.signOutAlert,
                                               preffedStyle: .actionSheet,
                                               okTitle: LocalizedString.ok,
                                               cancelTitle: LocalizedString.cancel,
                                               completion: completion)
        case .statisticsModule:
            let mainStatisticsViewController = configureStatisticsModuleScreen()
            navigationController?.pushViewController(mainStatisticsViewController, animated: true)
            sideMenu?.dismiss(animated: true, completion: nil)
        case .statisticForChoosenTraining(statistics: let statistics):
            let choosenStatisticsViewController = configureTVSModule(for: statistics)
            navigationController?.pushViewController(choosenStatisticsViewController, animated: true)
        }
        return true
    }

    // MARK: - Configuration methods
    private func configurateSideMenu() -> SideMenuNavigationController {
        let sideMenuModel = SideMenuModel()
        let sideMenuViewModel = SideMenuViewModel(model: sideMenuModel)
        let sideMenu = SideMenuViewController(viewModel: sideMenuViewModel)
        let menu = SideMenuNavigationController(rootViewController: sideMenu)
        menu.leftSide = false
        menu.menuWidth = Constants.sideMenuWidth
        menu.statusBarEndAlpha = 0.0
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.presentingEndAlpha = 0.4
        menu.navigationBar.isHidden = true
        menu.modalPresentationStyle = .overCurrentContext
        menu.view.backgroundColor = .red
        return menu
    }
    
    private func configureRecomendationViewController() -> RecomendationsViewController {
        let recomendationVC = RecomendationsViewController()
        let recomendationViewModel = RecomendationViewModel()
        let recomendationModel = RecomendationModel()
        recomendationVC.viewModel = recomendationViewModel
        recomendationViewModel.model = recomendationModel
        recomendationModel.ouptup = recomendationViewModel
        return recomendationVC
    }
    
    private func configureTrainingListStatistics() -> TrainingListStatisticViewController {
        let trainingListStatisticsModel = TrainingListStatisticsModel()
        let trainingListStatisticsViewModel = TrainingListStatisticsViewModel(model: trainingListStatisticsModel)
        let trainingListStatisticsVC = TrainingListStatisticViewController(viewModel: trainingListStatisticsViewModel)
        return trainingListStatisticsVC
    }
    
    private func configureStatisticsModuleScreen() -> MainStatisticsViewController {
        let mainStatisticsViewModel = MainStatisticViewModel()
        let mainStatisticsViewController = MainStatisticsViewController(viewModel: mainStatisticsViewModel)
        return mainStatisticsViewController
    }
    
    func configureTVSModule(for train: Statistics) -> ChoosenTrainingStatisticsViewController {
        let choosenStatisticsViewModel = ChoosenTrainingStatisticsViewModel(statistics: train)
        let choosenStatisticsViewController = ChoosenTrainingStatisticsViewController(viewModel: choosenStatisticsViewModel)
        return choosenStatisticsViewController
    }
    
}
