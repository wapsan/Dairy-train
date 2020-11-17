import Firebase

final class SideMenuModel {
    
    //MARK: - Properties
    var succesLogOut: (() -> Void)?
    var errorLogOut: ((_:Error) -> Void)?
    
    //MARK: - Public methods
    func signOut() {
        do {
            try Auth.auth().signOut()
            DTSettingManager.shared.deleteUserToken()
            CoreDataManager.shared.removeAllUserData { [weak self] in
                self?.succesLogOut?()
            }
        } catch let signOutError {
            self.errorLogOut?(signOutError)
        }
    }
}
