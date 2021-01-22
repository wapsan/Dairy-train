import Foundation

protocol SideMenuViewModelProtocol {
    var sideMenuItems: [SideMenuModel.MenuItem] { get }
    func menuItemSelected(at index: Int)
}

final class SideMenuViewModel {
    
    //MARK: - Properties
    private var model: SideMenuModel
    var router: SideMenuRouterProtocol?
    
    //MARK: - Initialization
    init(model: SideMenuModel) {
        self.model = model
        model.succesLogOut = { [weak self] in
            self?.router?.showAuhorizationScreen()
        }
        model.errorLogOut = {
            print($0)
        }
    }
}

//MARK: - SideMenuProtocol
extension SideMenuViewModel: SideMenuViewModelProtocol {
    
    var sideMenuItems: [SideMenuModel.MenuItem] {
        SideMenuModel.MenuItem.allCases
    }
    
    func menuItemSelected(at index: Int) {
        let menuItem = sideMenuItems[index]
        router?.showScreen(for: menuItem)
    }
}
 
// MARK: - SideMenuRouterOutput
extension SideMenuViewModel: SideMenuRouterOutput {
    
    func signOut() {
        model.signOut()
    }
}
