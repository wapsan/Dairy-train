import Firebase

protocol SideMenuModelOutput: AnyObject {
    func successLogOut()
    func errorLogout(with errorMessage: String)
}

final class SideMenuModel {
    
    // MARK: - Types
    enum MenuItem: CaseIterable {
        case premium
        case setting
        case termAndConditions
        case logOut
        
        var image: UIImage? {
            switch self {
            case .setting:
                return nil
            case .logOut:
                return nil
            case .premium:
                return nil
            case .termAndConditions:
                return nil
            }
        }
        
        var title: String {
            switch self {
            case .setting:
                return LocalizedString.setting
            case .logOut:
                return LocalizedString.signOut
            case .premium:
                return "Premium"
            case .termAndConditions:
                return "Terms & conditions"
            }
        }
    }

    weak var output: SideMenuModelOutput?
    
    //MARK: - Public methods
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
