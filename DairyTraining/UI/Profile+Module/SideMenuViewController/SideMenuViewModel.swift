import Foundation

final class SideMenuViewModel {
    
    //MARK: - Properties
    private var model: SideMenuModel
    
    var sideMenuItems: [SideMenuItem] {
        SideMenuItem.allCases
    }
    
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
    
    //MARK: - Public methods
    func menuItemSelected(at index: Int) {
        let menuItem = sideMenuItems[index]
        switch menuItem {
        case .supplyRecomendation:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.recomendation)
        case .statistics:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.statisticsModule)
        case .setting:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.setting)
        case .logOut:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.signOut(completion: model.signOut))
        }
    }
}
