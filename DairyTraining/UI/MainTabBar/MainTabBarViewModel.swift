import UIKit

protocol MainTabBarViewModelProtocol {
    var viewControllers: [UINavigationController] { get }
    var defaultControllerIndex: Int { get }
    
    func centeredAddButtonPressed()
}

final class MainTabBarViewModel {
    
    private let model: MainTabBarModelProtocol
    weak var view: MainTabBarViewProtocol?
    var router: MainTabBarRouterProtocol?
    
    init(model: MainTabBarModelProtocol) {
        self.model = model
    }
}

extension MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    func centeredAddButtonPressed() {
        router?.showCreateTrainingoptionsPopUpScreen()
    }
    
    var defaultControllerIndex: Int {
        return MainTabBarModel.Controller.home.controllerIndex
    }
    
    var viewControllers: [UINavigationController] {
        return MainTabBarModel.Controller.allCases.map({ $0.navigationController })
    }
}
