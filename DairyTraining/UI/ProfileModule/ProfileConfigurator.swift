import UIKit

final class ProfileConfigurator {
    
    static func confgiureProfileModule() -> UINavigationController {
        let profileModel = ProfileModel()
        let profileViewModel = ProfileViewModel(model: profileModel)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        let profileRouter = ProfileRouter(profileViewController)
        profileViewModel.view = profileViewController
        profileViewModel.router = profileRouter
        profileModel.output = profileViewModel
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.tabBarItem = MainTabBarModel.Item.profile.item
        navigationController.view.backgroundColor = DTColors.backgroundColor
        profileViewController.navigationItem.title = MainTabBarModel.Item.profile.title
        return navigationController
    }
}
