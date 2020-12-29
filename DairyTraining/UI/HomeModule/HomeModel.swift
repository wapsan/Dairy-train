import Foundation

protocol HomeModelProtocol {
    var menuItems: [HomeMenuItem] { get }
    
    func getMenuItemForIndex(index: Int) -> HomeMenuItem
    func callMenuItemAction(for index: Int)
    func showSideMenu()
}


final class HomeModel {
    
}

// MARK: - HomeModelProtocol
extension HomeModel: HomeModelProtocol {
    
    func showSideMenu() {
        MainCoordinator.shared.coordinate(to: HomeCoordinator.Target.sideMenu)
    }
    
    var menuItems: [HomeMenuItem] {
        return HomeMenuItem.allCases
    }
    
    func getMenuItemForIndex(index: Int) -> HomeMenuItem {
        return menuItems[index]
    }
    
    func callMenuItemAction(for index: Int) {
        menuItems[index].onAction()
    }
}
