import Foundation
import Firebase

protocol ProfileModelOutput: AnyObject {
    func succesSignedOut()
    func errorSignedOut(error: Error)
}

protocol ProfileModelIteracting: AnyObject {
    func signOut()
    var isMainInfoSet: Bool { get }
}

class ProfileModel {
    
    //MARK: - Private properties
    weak var output: ProfileModelOutput?

}

//MARK: - ProfileModelIteracting
extension ProfileModel: ProfileModelIteracting {
    
    var isMainInfoSet: Bool {
        guard let userMainInfo = CoreDataManager.shared.readUserMainInfo() else {
            return false
        }
        return userMainInfo.isSet
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DTSettingManager.shared.deleteUserToken()
            CoreDataManager.shared.removeAllUserData { [weak self] in
                guard let self = self else { return }
                self.output?.succesSignedOut()
            }
        } catch let signOutError {
            self.output?.errorSignedOut(error: signOutError)
        }
    }
}
