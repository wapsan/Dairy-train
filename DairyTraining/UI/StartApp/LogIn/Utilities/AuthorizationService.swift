import GoogleSignIn
import Firebase

protocol AuthorizationServiceProotocol {
    func signIn(with provider: AuthorizationService.Provider)
    func signOut()
    
    var delegate: AuthorizationServiceDelegate? { get set }
}

enum SocialMediaError: Error {
    case unknowError(errorMessage: String)
}

protocol AuthorizationServiceDelegate: AnyObject {
    func startGoogleSigningIn()
    func errorSignIn(error: Error)
    func successSignIn(token: String)
    func signOutWithError(error: SocialMediaError)
    func signOutWithSucces()
}

final class AuthorizationService: NSObject {
    
    //MARK: - Internal properites
    weak var delegate: AuthorizationServiceDelegate?
    
    //MARK: - Types
    enum Provider {
        case google
        case facebook
        case apple
    }
    
    //MARK: - Initialization
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
}

//MARK: - GoogleSignInServiceProtocol
extension AuthorizationService: AuthorizationServiceProotocol {
    
    func signIn(with provider: Provider) {
        switch provider {
        case .google:
            GIDSignIn.sharedInstance()?.signIn()
            
        case .facebook:
            break
            
        case .apple:
            break
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            delegate?.signOutWithSucces()
        } catch {
            delegate?.signOutWithError(error: .unknowError(errorMessage: "Can not to sign out"))
        }
    }
}

//MARK: - GIDSignInDelegate
extension AuthorizationService: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            delegate?.errorSignIn(error: error)
            return
        }
        
        if let _ = user { delegate?.startGoogleSigningIn() }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (result, error) in
            guard let self = self else { return }
            if let token = result?.user.refreshToken {
                self.delegate?.successSignIn(token: token)
              
            } else {
                self.delegate?.signOutWithError(error: .unknowError(errorMessage: "Token doesnt exist"))
            }
        }
    }
}
