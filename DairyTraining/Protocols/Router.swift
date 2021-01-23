import UIKit

protocol Router {
    
    init(_ viewController: UIViewController)
    
    var mainTabBar: UITabBarController? { get }
    var topViewController: UIViewController? { get }
    var window: UIWindow? { get }
    
    func showExerciseFlow()
    func showPaternFlow()
    func showSearchFoodFlow()
    func showReadyWorkoutsFlow()
}


extension Router {

    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard var topController = keyWindow?.rootViewController else {
            return nil
        }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    var mainTabBar: UITabBarController? {
        return UIApplication.topViewController()?.tabBarController
    }
    
    var window: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    func showExerciseFlow() {
        let muscleGroupViewController = MuscleGroupsViewControllerConfigurator().configure(for: .training)
        let navigationController = UINavigationController(rootViewController: muscleGroupViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showPaternFlow() {
        let trainingPaternViewController = TrainingPaternsViewControllerConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: trainingPaternViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showSearchFoodFlow() {
        let searchFoodViewController = SearchFoodConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: searchFoodViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func showReadyWorkoutsFlow() {
        let trainingLevelsScreen = TrainingProgramsLevelsConfigurator().configure()
        let navigationController = UINavigationController(rootViewController: trainingLevelsScreen)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
}
