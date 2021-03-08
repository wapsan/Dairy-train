import Firebase

protocol SideMenuInteractorProtocol {
    func signOut()
}

protocol SideMenuInteractorOutput: AnyObject {
    
    func successLogOut()
    func errorLogout(with errorMessage: String)
}

final class SideMenuInteractor {
    
    //MARK: - Internal properties
    weak var output: SideMenuInteractorOutput?
}

//MARK: - SideMenuInteractorProtocol
extension SideMenuInteractor: SideMenuInteractorProtocol {
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            SettingManager.shared.deleteUserToken()
            NutritionDataManager.shared.removeNutritionData()
            UserDataManager.shared.removeAllUserData { [weak self] in
                self?.output?.successLogOut()
            }
            
        } catch let signOutError {
            self.output?.errorLogout(with: signOutError.localizedDescription)
        }
    }
}
