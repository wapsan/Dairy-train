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
    private let coreDataManager: UserDataManager = UserDataManager.shared
    private let firebaseAuth: Auth = Auth.auth()
    
    //MARK: - Initialization
    init() {
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
                break
            }
        }
    }
    
    private func updateData(from firebaseServerModel: FrebaseServerModel) {
        if let userMainInfo = firebaseServerModel.userMainInfo {
            self.coreDataManager.updateUserMainInfo(to: userMainInfo)
            NotificationCenter.default.post(name: .mainInfoWasUpdated, object: nil)
        }
        self.coreDataManager.updateDateOfLastUpdateTo(firebaseServerModel.dateOfUpdate)
        TrainingDataManager.shared.updateUserTrainInfoFrom(firebaseServerModel.trainingList)
        TrainingDataManager.shared.updateTrainingPaternList(to: firebaseServerModel.trainingPaternList)
        NutritionDataManager.shared.updateHistoryNutritionData(from: firebaseServerModel.dayNutritionCodableModel)
        NutritionDataManager.shared.updateCustomNutritionMode(from: firebaseServerModel.customnutritionMode)
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
