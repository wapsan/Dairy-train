import UIKit

protocol MainTabBarPresentProtocol {
    var viewControllers: [UINavigationController] { get }
    var defaultControllerIndex: Int { get }
    
    func centeredAddButtonPressed()
}

final class MainTabBarPresenter {
    
    //MARK: - Internal properties
    weak var view: MainTabBarViewProtocol?
    var router: MainTabBarRouterProtocol?
    
    //MARK: - Private
    private let model: MainTabBarModelProtocol
    
    //MARK: - Initialization
    init(model: MainTabBarModelProtocol) {
        self.model = model
    }
}

//MARK: - MainTabBarPresentProtocol
extension MainTabBarPresenter: MainTabBarPresentProtocol {
    
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
