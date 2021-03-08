import UIKit
import Firebase

protocol HomeInteractorProtocol {
    var menuItems: [HomeInteractor.MenuItem] { get }
    
    func getMenuItemForIndex(index: Int) -> HomeInteractor.MenuItem
}

final class HomeInteractor {
    
}

// MARK: - HomeModelProtocol
extension HomeInteractor: HomeInteractorProtocol {
    
    var menuItems: [MenuItem] {
        return MenuItem.allCases
    }
    
    func getMenuItemForIndex(index: Int) -> MenuItem {
        return menuItems[index]
    }
}
