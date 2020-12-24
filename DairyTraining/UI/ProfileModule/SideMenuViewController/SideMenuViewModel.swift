import Foundation

protocol SideMenuViewModelProtocol {
    var sideMenuItems: [SideMenuItem] { get }
    func menuItemSelected(at index: Int)
}

final class SideMenuViewModel {
    
    //MARK: - Properties
    private var model: SideMenuModel
    
    //MARK: - Initialization
    init(model: SideMenuModel) {
        self.model = model
        model.succesLogOut = {
            MainCoordinator.shared.coordinate(to: MainCoordinator.Target.loginFlow)
        }
        model.errorLogOut = {
            print($0)
        }
    }
}

//MARK: - SideMenuProtocol
extension SideMenuViewModel: SideMenuViewModelProtocol {
    
    var sideMenuItems: [SideMenuItem] {
        SideMenuItem.allCases
    }
    
    func menuItemSelected(at index: Int) {
        let menuItem = sideMenuItems[index]
        switch menuItem {
        case .statistics:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.statisticsByTraining)
        case .setting:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.setting)
        case .logOut:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.signOut(completion: model.signOut))
        case .premium:
            break
        case .termAndConditions:
            break
        }
    }
}
