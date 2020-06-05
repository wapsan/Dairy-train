import Firebase
import GoogleSignIn

class AppAuthentication: NSObject, GIDSignInDelegate {
   
    //MARK: - Singletone propertie
    static let shared = AppAuthentication()
    
    //MARK: - Publick methods
    func initAuth() {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func handle(url: URL) -> Bool {
         return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if let token = result?.user.refreshToken {
                DTSettingManager.shared.setUserToken(to: token)
                self.postNotificationForGoogleSingIn()
            } else {
                print("GooglSignInErrro")
            }
        }
    }
    
    //MARK: - Private methods
    private func postNotificationForGoogleSingIn() {
        NotificationCenter.default.post(name: .googleSignIn,
                                        object: nil,
                                        userInfo: nil)
    }
    
}
