import Foundation

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
    
    //MARK: - Private properies
    private let persistenceService: PersistenceServiceProtocol
    private var authorizationService: AuthorizationServiceProotocol
    
    
    init(persistenceService: PersistenceServiceProtocol = PersistenceService(),
         authorizationService: AuthorizationServiceProotocol = AuthorizationService()) {
        self.persistenceService = persistenceService
        self.authorizationService = authorizationService
        self.authorizationService.delegate = self
    }
}

//MARK: - SideMenuInteractorProtocol
extension SideMenuInteractor: SideMenuInteractorProtocol {
    
    func signOut() {
        authorizationService.signOut()
    }
}

//MARK: - AuthorizationServiceDelegate
extension SideMenuInteractor: AuthorizationServiceDelegate {
    
    func startGoogleSigningIn() {
        return
    }
    
    func errorSignIn(error: Error) {
        return
    }
    
    func successSignIn(token: String) {
        return
    }
    
    func signOutWithError(error: SocialMediaError) {
        switch error {
        case .unknowError(errorMessage: let errorMessage):
            output?.errorLogout(with: errorMessage)
        }
    }
    
    func signOutWithSucces() {
        UserDefaults.standard.deleteToken()
        persistenceService.user.cleanUserData()
        persistenceService.workout.cleanAllWorkoutsData()
        persistenceService.nutrition.removeAllNutritonData()
        output?.successLogOut()
    }
}
