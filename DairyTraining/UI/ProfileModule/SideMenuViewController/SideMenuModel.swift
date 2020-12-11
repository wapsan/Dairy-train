import Firebase

final class SideMenuModel {
    
    //MARK: - Properties
    var succesLogOut: (() -> Void)?
    var errorLogOut: ((_:Error) -> Void)?
    
    //MARK: - Public methods
    func signOut() {
        do {
            try Auth.auth().signOut()
            SettingManager.shared.deleteUserToken()
            UserDataManager.shared.removeAllUserData { [weak self] in
                self?.succesLogOut?()
            }
        } catch let signOutError {
            self.errorLogOut?(signOutError)
        }
    }
}
