import Foundation
import Firebase

protocol ProfileModelOutput: AnyObject {
    func succesSignedOut()
    func errorSignedOut(error: Error)
}

protocol ProfileModelIteracting: AnyObject {
    func signOut()
}

class ProfileModel {
    
    //MARK: - Private properties
    var output: ProfileModelOutput!
    
    //MARK: - Private properties
    private var firebaseAuth: Auth
    private var coreDataManager: CoreDataManager
    private var settingManager: DTSettingManager
    
    //MARK: - Initialization
    init(firebaseAuth: Auth = Auth.auth(),
         coreData: CoreDataManager = CoreDataManager.shared,
         settingManager: DTSettingManager = DTSettingManager.shared) {
        self.firebaseAuth = firebaseAuth
        self.coreDataManager = coreData
        self.settingManager = settingManager
    }
}

//MARK: - ProfileModelIteracting
extension ProfileModel: ProfileModelIteracting {

    func signOut() {
        do {
            try self.firebaseAuth.signOut()
            self.settingManager.deleteUserToken()
            self.coreDataManager.removeAllUserData({ [weak self] in
                guard let self = self else { return }
                self.output.succesSignedOut()
            })
        } catch let signOutError {
            self.output.errorSignedOut(error: signOutError)
        }
    }
}
