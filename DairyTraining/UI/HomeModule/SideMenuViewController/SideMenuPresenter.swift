import Foundation

protocol SideMenuPresenterProtocol {
    var sideMenuItems: [SideMenuInteractor.MenuItem] { get }
    func menuItemSelected(at index: Int)
}

final class SideMenuPresenter {
    
    //MARK: - Internal properties
    var router: SideMenuRouterProtocol?
    
    //MARK: - Properties
    private var interactor: SideMenuInteractor
    
    //MARK: - Initialization
    init(interactor: SideMenuInteractor) {
        self.interactor = interactor
    }
    
    //MARK: - Private methods
    private func showSignOutAlert() {
        router?.showSignOutAlert(with: { [weak self] in
            self?.interactor.signOut()
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
extension SideMenuPresenter: SideMenuPresenterProtocol {
    
    var sideMenuItems: [SideMenuInteractor.MenuItem] {
        SideMenuInteractor.MenuItem.allCases
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

//MARK: - SideMenuInteractorOutput
extension SideMenuPresenter: SideMenuInteractorOutput {
    
    func successLogOut() {
        router?.showAuhorizationScreen()
    }
    
    func errorLogout(with errorMessage: String) {
        router?.showInfoAlert(with: errorMessage)
    }
}
