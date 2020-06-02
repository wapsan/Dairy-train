//
//  AppAuthentication.swift
//  DairyTrain2.0
//
//  Created by Вячеслав on 01.06.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import Firebase
import GoogleSignIn

class AppAuthentication: NSObject, GIDSignInDelegate {
   
    //MARK: - Shared properties
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
            if result != nil {
                guard let token = result?.user.refreshToken else { return }
                userDefaults.set(token, forKey: UserTokenKey)
                NotificationCenter.default.post(name: .googleSignIn,
                                                object: nil,
                                                userInfo: nil)
            } else {
                print("GooglSignInErrro")
            }
        }
    }
}
