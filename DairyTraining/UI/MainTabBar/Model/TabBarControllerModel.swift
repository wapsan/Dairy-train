import UIKit

enum DTTabBarItems {
    case home
    case nutrition
    case addButton
    case profile
    case training
    
    private var tag: Int {
        switch self {
        case .nutrition:
            return 1
        case .profile:
            return 3
        case .training:
            return 2
        case .home:
            return 0
        case .addButton:
            return 4
        }
    }
    
    private var image: UIImage? {
        switch self {
        case .nutrition:
            return UIImage(named: "nutrition")
        case .profile:
            return UIImage.tabBarProfile
        case .training:
            return UIImage.tabBarTrains
        case .home:
            return UIImage(named: "iconhome")
        case .addButton:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .nutrition:
            return "Nutrition"
        case .profile:
            return LocalizedString.profile
        case .training:
            return LocalizedString.training
        case .home:
            return "Home"
        case .addButton:
            return ""
        }
    }
    
    var item: UITabBarItem {
        let item = UITabBarItem(title: nil,
                                image: image,
                                tag: tag)
        item.imageInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        return item
    }
}

enum TabBarItemController {
    case home
    case profile
    case addButton
    case trainingBlock
    case supplyBlock
    
    var navigationController: UINavigationController {
        switch self {
        case .profile:
            return configureProfileNavigationController()
        case .trainingBlock:
            return configureTrainingBlockNabigationController()
        case .supplyBlock:
           return configureSupplyBlockNavigationController()
        case .home:
            return HomeViewControllerConfigurator.configureHomeNavigationControllet()
        case .addButton:
            return UINavigationController(rootViewController: UIViewController())
        }
    }
    
    private func configureProfileNavigationController() -> UINavigationController {
        let testPVC = ProfileViewController()
        let testPVM = ProfileViewModel()
        let testPM = ProfileModel()
        let testPR = ProfileRouter(testPVC)
        testPVC.router = testPR
        testPVC.viewModel = testPVM
        testPVM.view = testPVC
        testPVM.model = testPM
        testPM.output = testPVM
        let navigationController = UINavigationController(rootViewController: testPVC)
        navigationController.tabBarItem = DTTabBarItems.profile.item
        navigationController.view.backgroundColor = DTColors.backgroundColor
        testPVC.navigationItem.title = DTTabBarItems.profile.title
        return navigationController
    }
    
    private func configureTrainingBlockNabigationController() -> UINavigationController {
        let workoutsListViewController = WorkoutListViewControllerConfigurator.configure()
        let navigationController = UINavigationController(rootViewController: workoutsListViewController)
        navigationController.tabBarItem = DTTabBarItems.training.item
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func configureSupplyBlockNavigationController() -> UINavigationController {
        let nutritionModel = NutritionModel()
        let nutritionViewModel = NutritionViewModel(model: nutritionModel)
        let nutritionViewController = MainNutritionVIewController(viewModel: nutritionViewModel)
        nutritionModel.output = nutritionViewModel
        nutritionViewModel.view = nutritionViewController
        let navigationController = UINavigationController(rootViewController: nutritionViewController)
        navigationController.tabBarItem = DTTabBarItems.nutrition.item
        nutritionViewController.navigationItem.title = DTTabBarItems.nutrition.title
        return navigationController
    }
}
