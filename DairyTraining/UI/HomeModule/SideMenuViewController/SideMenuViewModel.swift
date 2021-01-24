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
    }
    
    //MARK: - Private methods
    private func showSignOutAlert() {
        router?.showSignOutAlert(with: { [weak self] in
            self?.model.signOut()
        })
    }
    
    private func showSettingScreen() {
        router?.showSettingScreen()
    }
    
    private func showTermsAndConditionScreen() {
        router?.showTermsAndConditionsScreen()
    }
}

//MARK: - SideMenuProtocol
extension SideMenuViewModel: SideMenuViewModelProtocol {
    
    var sideMenuItems: [SideMenuModel.MenuItem] {
        SideMenuModel.MenuItem.allCases
    }
    
    func menuItemSelected(at index: Int) {
        let menuItem = sideMenuItems[index]
        switch menuItem {
        case .premium:
            break
        case .setting:
            showSettingScreen()
        case .termAndConditions:
            showTermsAndConditionScreen()
        case .logOut:
            showSignOutAlert()
        }
    }
}

extension SideMenuViewModel: SideMenuModelOutput {
    
    func successLogOut() {
        router?.showAuhorizationScreen()
    }
    
    func errorLogout(with errorMessage: String) {
        router?.showInfoAlert(with: errorMessage)
    }
}
