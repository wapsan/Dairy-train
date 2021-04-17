import GoogleSignIn
import Firebase

protocol AuthorizationInteractorOutput: AnyObject {
    func succesSignIn()
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
    private let googleSignIn: GIDSignIn = GIDSignIn.sharedInstance()
    private let firebaseManager: FirebaseDataManager = FirebaseDataManager.shared
    private let firebaseAuth: Auth = Auth.auth()
    private let persistenceService: PersistenceService
    
    //MARK: - Initialization
    init(persistenceService: PersistenceService = PersistenceService()) {
        self.persistenceService = persistenceService
        addObserveForGoogleSignedIn()
        addObserverForStartGoogleSignIn()
    }
    
    //MARK: - Actions
    @objc private func googleStartSignIn() {
        self.output?.googleStartSignIn()
        NotificationCenter.default.removeObserver(self, name: .startGoogleSignIn, object: nil)
    }
    
    @objc private func googelSignedIn() {
        self.synhronizeDataFreomServer()
        NotificationCenter.default.removeObserver(self, name: .googleSignIn, object: nil)
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
                self.output?.succesSignIn()
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
    
    private func addObserveForGoogleSignedIn() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.googelSignedIn),
                                               name: .googleSignIn,
                                               object: nil)
    }
    
    private func addObserverForStartGoogleSignIn() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.googleStartSignIn),
                                               name: .startGoogleSignIn,
                                               object: nil)
    }
}

//MARK: - LoginModelIteracting
extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
    func signInWithApple() {
        //add realization
    }
    
    func signInWithFacebook() {
        //add realization
    }
    
    func signInWithGoogle() {
        googleSignIn.signIn()
    }
}
