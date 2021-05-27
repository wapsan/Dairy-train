import Foundation

protocol AuthorizationInteractorOutput: AnyObject {
    func succesSignIn()
    func failureSignIn()
    func googleStartSignIn()
}

protocol AuthorizationInteractorProtocol {
    func signInWithGoogle()
    func signInWithApple()
    func signInWithFacebook()
}

final class AuthorizationInteractor {
    
    //MARK: - Internal Properies
    weak var output: AuthorizationInteractorOutput?
    
    //MARK: - Private properties
    private let firebaseManager: FirebaseDataManager = FirebaseDataManager.shared
    private let persistenceService: PersistenceService
    private var authorizationService: AuthorizationServiceProotocol
    
    //MARK: - Initialization
    init(persistenceService: PersistenceService = PersistenceService(),
         authorizationService: AuthorizationServiceProotocol = AuthorizationService()) {
        self.persistenceService = persistenceService
        self.authorizationService = authorizationService
        self.authorizationService.delegate = self
    }
    
    //MARK: - Private methods
    private func synhronizeDataFreomServer() {
        firebaseManager.fetchDataFromFirebase { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let dataModel):
                self.updateData(from: dataModel)
                self.output?.succesSignIn()
            case .failure(_):
                self.output?.failureSignIn()
                break
            }
        }
    }
    
    private func updateData(from firebaseServerModel: FrebaseServerModel) {
        
        if let userMainInfo = firebaseServerModel.userMainInfo {
            persistenceService.user.updateUserInfo(.user(user: userMainInfo))
            NotificationCenter.default.post(name: .mainInfoWasUpdated, object: nil)
            
        }
        persistenceService.user.updateUserInfo(.updateDate(date: firebaseServerModel.dateOfUpdate))
        
        let workouts = firebaseServerModel.trainingList
        let workoutsTemplates = firebaseServerModel.trainingPaternList
        persistenceService.workout.syncWorkoutsFromFirebase(workouts: workouts)
        persistenceService.workoutTemplates.updateWorkoutTemplatesList(from: workoutsTemplates)
        
        persistenceService.nutrition.syncCustomNutritonMode(from: firebaseServerModel.customnutritionMode)
        persistenceService.nutrition.syncAllNutritionData(from: firebaseServerModel.dayNutritionCodableModel)
    }
}

//MARK: - AuthorizationInteractorProtocol
extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
    func signInWithApple() {
        authorizationService.signIn(with: .apple)
    }
    
    func signInWithFacebook() {
        authorizationService.signIn(with: .facebook)
    }
    
    func signInWithGoogle() {
        authorizationService.signIn(with: .google)
    }
}

//MARK: - AuthorizationServiceDelegate
extension AuthorizationInteractor: AuthorizationServiceDelegate {
    
    func startGoogleSigningIn() {
        output?.googleStartSignIn()
    }
    
    func errorSignIn(error: Error) {
        output?.failureSignIn()
    }
    
    func successSignIn(token: String) {
        UserDefaults.standard.setToken(token: token)
        synhronizeDataFreomServer()
        output?.succesSignIn()
    }
    
    func signOutWithError(error: SocialMediaError) {
        return
    }
    
    func signOutWithSucces() {
        return
    }
}
