import Firebase
import GoogleSignIn

final class GoogleAuthorizationManager: NSObject, GIDSignInDelegate {
    
    //MARK: - Singletone propertie
    static let shared = GoogleAuthorizationManager()
    
    //MARK: - Initialization
    private override init() {
        super.init()
    }
    
    //MARK: - Publick methods
    func initAuth() {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func handle(url: URL) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //MARK: - APIs methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if let _ = user {
            self.postNotificationForStartGoogleSignIn()
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (result, error) in
            guard let self = self else { return }
            if let token = result?.user.refreshToken {
                SettingManager.shared.setUserToken(to: token)
                self.postNotificationForGoogleSingedIn()
            } else {
                print("GooglSignInErrro")
            }
        }
    }
    
    //MARK: - Private methods
    private func postNotificationForGoogleSingedIn() {
        NotificationCenter.default.post(name: .googleSignIn,
                                        object: nil,
                                        userInfo: nil)
    }
    
    private func postNotificationForStartGoogleSignIn() {
        NotificationCenter.default.post(name: .startGoogleSignIn, object: nil)
    }
}
