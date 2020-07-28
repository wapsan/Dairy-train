import Foundation
import GoogleSignIn
import Firebase

protocol LoginModelDelegate: AnyObject {
    func startSigninIn()
    func succesSignIn()
    func failedSignIn(with error: Error)
    func succesSignUp()
    func failedSignUp(with error: Error)
    func googleStartSignIn()
}

final class LoginModel {
    
    //MARK: - Private properties
    private let googleSignIn: GIDSignIn?
    private let firebaseManager: DTFirebaseFileManager
    private let coreDataManager: CoreDataManager
    private let firebaseAuth: Auth
    
    //MARK: - Properties
    var delegate: LoginModelDelegate!
    
    //MARK: - Initialization
    init(googleSignIn: GIDSignIn? = GIDSignIn.sharedInstance(),
         firebaseManager: DTFirebaseFileManager = DTFirebaseFileManager.shared,
         coreDataManager: CoreDataManager = CoreDataManager.shared,
         firebaseAuth: Auth = Auth.auth()) {
        self.googleSignIn = googleSignIn
        self.firebaseManager = firebaseManager
        self.coreDataManager = coreDataManager
        self.firebaseAuth = firebaseAuth
        self.addObserveForGoogleSignedIn()
        self.addObserverForStartGoogleSignIn()
    }
    
    //MARK: - Public methods
    func setUpGooglePresentingViewController(to viewController: UIViewController) {
        self.googleSignIn?.presentingViewController = viewController
    }
    
    func signUp(with email: String?, and password: String?) {
        guard let email = email, let password = password else { return }
        self.firebaseAuth.createUser(withEmail: email, password: password) { (result, error) in
            if let _ = result {
                self.delegate.succesSignUp()
            }
            if let error = error {
                self.delegate.failedSignUp(with: error)
            }
        }
    }
    
    func signIn(with email: String?, and password: String?) {
        guard let email = email, let password = password else { return }
        self.firebaseAuth.signIn(withEmail: email, password: password) { (result, error) in
            if let _ = result {
                self.delegate.startSigninIn()
                self.synhronizeDataFreomServer()
            }
            if let error = error {
                self.delegate.failedSignIn(with: error)
            }
        }
    }
    
    func signInWithGoogle() {
        self.googleSignIn?.signIn()
    }
    
    //MARK: - Actions
    @objc private func googleStartSignIn() {
        self.delegate.googleStartSignIn()
        NotificationCenter.default.removeObserver(self, name: .startGoogleSignIn, object: nil)
    }
    
    @objc private func googelSignedIn() {
        print("Google signed in")
        self.synhronizeDataFreomServer()
        NotificationCenter.default.removeObserver(self, name: .googleSignIn, object: nil)
    }
    
    //MARK: - Private methods
    private func synhronizeDataFreomServer() {
        self.firebaseManager.synhronizeDataFromServer { [weak self] (mainData, trainingList, dateOfUpdate) in
            guard let self = self else { return }
            if let mainData = mainData {
                self.coreDataManager.updateUserMainInfo(to: mainData)
            }
            self.coreDataManager.updateDateOfLastUpdateTo(dateOfUpdate)
            self.coreDataManager.updateUserTrainInfoFrom(trainingList)
            self.delegate.succesSignIn()
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
