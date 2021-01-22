import UIKit

final class ProfileConfigurator {
    
    static func confgiureProfileModule() -> UINavigationController {
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
        navigationController.tabBarItem = MainTabBarModel.Item.profile.item
        navigationController.view.backgroundColor = DTColors.backgroundColor
        testPVC.navigationItem.title = MainTabBarModel.Item.profile.title
        return navigationController
    }
    
}
