import UIKit


fileprivate enum DTTabBarItems {
    case nutrition
    case profile
    case training
    
    private var tag: Int {
        switch self {
        case .nutrition:
            return 0
        case .profile:
            return 2
        case .training:
            return 1
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
        }
    }
    
    var item: UITabBarItem {
        let item = UITabBarItem(title: nil,
                                image: image,
                                tag: tag)
        item.imageInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        return item
    }
}

enum TabBarItemController {
    case profile
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
        let trainingListModel = TrainingListModel()
        let trainingListViewModel = TrainingListViewModel(model: trainingListModel)
        let trainingListViewController = TrainingListViewController(viewModel: trainingListViewModel)
       // let trainingListVC = TrainingListViewController()
        //let trainingListVM = TrainingListViewModel()
        //let trainingListM = TrainingListModel()
      //  let trainingListR = TrainingListRouter(trainingListVC)
      //  trainingListVC.viewModel = trainingListVM
       // trainingListViewModel.router = trainingListR
        trainingListViewModel.view = trainingListViewController
      //  trainingListVM.model = trainingListM
        trainingListModel.output = trainingListViewModel
        let navigationController = UINavigationController(rootViewController: trainingListViewController)
        navigationController.tabBarItem = DTTabBarItems.training.item
        trainingListViewController.navigationItem.title = DTTabBarItems.training.title
        return navigationController
    }
    
    private func configureSupplyBlockNavigationController() -> UINavigationController {
        let nutritionViewController = MainNutritionVIewController()
        let navigationController = UINavigationController(rootViewController: nutritionViewController)
        navigationController.tabBarItem = DTTabBarItems.nutrition.item
        nutritionViewController.navigationItem.title = DTTabBarItems.nutrition.title
        return navigationController
    }
}