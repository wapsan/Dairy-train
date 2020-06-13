import Foundation
import Firebase

class DTFireBaseFileManager {
    
    //MARK: - Singletone
    static let shared = DTFireBaseFileManager()
    
    //MARK: - Private properties
    private lazy var mainProfileInfo = ProfileInfoFileManager.shared
    private lazy var firebaseRedf = Database.database().reference()
    
    
    //MARK: - Public methods
    func updateMainUserInfo() {
        
    }
    
    
    
}
