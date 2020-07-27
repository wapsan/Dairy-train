import Foundation
import Firebase

protocol ProfileModelDelegate: AnyObject {
    func succesSignedOut()
    func errorSignedOut(error: Error)
}

class ProfileModel {
    
    //MARK: - Private properties
    var delegate: ProfileModelDelegate!
    
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
    
    //MARK: - Public methods
    func signOut() {
        do {
            try self.firebaseAuth.signOut()
            self.settingManager.deleteUserToken()
            self.coreDataManager.removeAllUserData({
                self.delegate.succesSignedOut()
            })
        } catch let signOutError {
            self.delegate.errorSignedOut(error: signOutError)
        }
    }
}
