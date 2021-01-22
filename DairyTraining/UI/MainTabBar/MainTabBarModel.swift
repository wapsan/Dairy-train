import UIKit

protocol MainTabBarModelProtocol {
    
}

final class MainTabBarModel {
    
    enum Item {
        case home
        case nutrition
        case addButton
        case training
        case profile
        
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

    enum Controller: Int, CaseIterable {
        case home = 0
        case supplyBlock
        case addButton
        case trainingBlock
        case profile
        
        var controllerIndex: Int {
            return self.rawValue
        }
        
        var navigationController: UINavigationController {
            switch self {
            case .profile:
                return ProfileConfigurator.confgiureProfileModule()
            case .trainingBlock:
                return WorkoutListViewControllerConfigurator.configureWorkoutModule()
            case .supplyBlock:
                return MainNutritionConfigurator.configureMainNutritionModule()
            case .home:
                return HomeViewControllerConfigurator.configureHomeNavigationControllet()
            case .addButton:
                return UINavigationController(rootViewController: UIViewController())
            }
        }
    }
}

extension MainTabBarModel: MainTabBarModelProtocol {
    
}
