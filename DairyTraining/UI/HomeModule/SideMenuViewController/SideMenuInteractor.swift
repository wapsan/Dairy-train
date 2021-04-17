import Firebase

protocol SideMenuInteractorProtocol {
    func signOut()
}

protocol SideMenuInteractorOutput: AnyObject {
    
    func successLogOut()
    func errorLogout(with errorMessage: String)
}

final class SideMenuInteractor {
    
    private let persistenceService: PersistenceServiceProtocol
    
    //MARK: - Internal properties
    weak var output: SideMenuInteractorOutput?
    
    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
    }
}

//MARK: - SideMenuInteractorProtocol
extension SideMenuInteractor: SideMenuInteractorProtocol {
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.deleteToken()
            persistenceService.user.cleanUserData()
            persistenceService.workout.cleanAllWorkoutsData()
            persistenceService.nutrition.removeAllNutritonData()
            output?.successLogOut()
            
        } catch let signOutError {
            self.output?.errorLogout(with: signOutError.localizedDescription)
        }
    }
}
