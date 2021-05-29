import XCTest
@testable import Dairy_Training

class TabBarControllerMock: UITabBarController {
    
    private var _presentedViewController: UIViewController?
    
    override var presentedViewController: UIViewController? {
        if let presentedNavigationController = _presentedViewController as? UINavigationController {
            return presentedNavigationController.topViewController
        } else {
            return  _presentedViewController
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        _presentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
}

class HomeNavigationController: UINavigationController {
    
    private var _topViewController: UIViewController?
    
    override var topViewController: UIViewController? {
        _topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        _topViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
}

class HomeViewControllerMock: UIViewController {

    var tabBarPresentedViewController: UIViewController? {
        return (tabBarController as? TabBarControllerMock)?.presentedViewController
    }
    
    var pushedController: UIViewController? {
        return (navigationController as? HomeNavigationController)?.topViewController
    }
    
}

extension HomeViewControllerMock: HomeView {
    
}



class HomeRouterTest: XCTestCase {
    
    var router: HomeRouter!
    var mockVC: HomeViewControllerMock!

    override func setUpWithError() throws {
        mockVC = .init()
        let _ = HomeNavigationController(rootViewController: mockVC)
        let tabBar = TabBarControllerMock()
        tabBar.viewControllers = [mockVC]
        router = HomeRouter(viewController: mockVC)
    }

    func testShowMonthlyStatistics() {
        router.showMonthlyStatisticsScreen()
        XCTAssertTrue(mockVC.pushedController is MonthlyStatisticsViewController)
    }
    
    func testSettingScreen() {
        router.pushSettingScreen()
        XCTAssertTrue(mockVC.pushedController is SettingsSectionViewController)
    }
    
    func testExerciseFlowScreen() {
        router.showExerciseFlow()
        XCTAssertTrue(mockVC.tabBarController?.presentedViewController  is MuscleGroupsViewController)
    }

    override func tearDownWithError() throws {
        mockVC = nil
        router = nil
    }
}
