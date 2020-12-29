import GoogleSignIn
import Firebase

protocol LoginModelOutput: AnyObject {
    func succesSignIn()
    func googleStartSignIn()
}

protocol AuthorizationModelProtocol {
    func signInWithGoogle()
    func signInWithApple()
    func signInWithFacebook()
}

final class AuthorizationModel {
    
    //MARK: - Private properties
    private let googleSignIn: GIDSignIn = GIDSignIn.sharedInstance()
    private let firebaseManager: FirebaseDataManager = FirebaseDataManager.shared
    private let coreDataManager: UserDataManager = UserDataManager.shared
    private let firebaseAuth: Auth = Auth.auth()
    
    //MARK: - Properties
    weak var output: LoginModelOutput?
    
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
                if let userMainInfo = dataModel.userMainInfo {
                    self.coreDataManager.updateUserMainInfo(to: userMainInfo)
                    NotificationCenter.default.post(name: .mainInfoWasUpdated, object: nil)
                }
                self.coreDataManager.updateDateOfLastUpdateTo(dataModel.dateOfUpdate)
                TrainingDataManager.shared.updateUserTrainInfoFrom(dataModel.trainingList)
                TrainingDataManager.shared.updateTrainingPaternList(to: dataModel.trainingPaternList)
                NutritionDataManager.shared.updateHistoryNutritionData(from: dataModel.dayNutritionCodableModel)
                NutritionDataManager.shared.updateCustomNutritionMode(from: dataModel.customnutritionMode)
                self.output?.succesSignIn()
            case .failure(_):
                break
            }
        }
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
extension AuthorizationModel: AuthorizationModelProtocol {
    
    func signInWithApple() {
        //add realization
    }
    
    func signInWithFacebook() {
        //add realization
    }
    
    func signInWithGoogle() {
        self.googleSignIn.signIn()
    }
}
