import Firebase
import GoogleSignIn

class AppAuthentication: NSObject, GIDSignInDelegate {
    
    //MARK: - Singletone propertie
    static let shared = AppAuthentication()
    
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
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let token = result?.user.refreshToken {
                DTSettingManager.shared.setUserToken(to: token)
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
