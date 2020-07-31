import UIKit

protocol LoginViewModelInput {
    func signIn(with email: String?, and password: String?)
    func signUp(with email: String?, and password: String?)
    func signInWithGoogle()
    func setUpGooglePresentingViewController()
}

final class LoginViewModel {
    
    //MARK: - Properties
    var view: LoginViewControllerPresenter!
    var model: LoginModel!
}

//MARK: - LoginViewModelInput
extension LoginViewModel: LoginViewModelInput {
    
    func signIn(with email: String?, and password: String?) {
        self.model.signIn(with: email, and: password)
    }
    
    func signUp(with email: String?, and password: String?) {
        self.model.signUp(with: email, and: password)
    }
    
    func signInWithGoogle() {
        self.model.signInWithGoogle()
    }
    
    func setUpGooglePresentingViewController() {
        guard let loginViewController = self.view as? LoginViewController else { return }
        self.model.setUpGooglePresentingViewController(to: loginViewController)
    }
}

//MARK: - LoginModelDelegate
extension LoginViewModel: LoginModelOutput {
    
    func startSigninIn() {
        self.view.startSigninIn()
    }
    
    func googleStartSignIn() {
        self.view.googleSignInStart()
    }
    
    func succesSignUp() {
        self.view.succesSignUp()
    }
    
    func failedSignUp(with error: Error) {
        self.view.failedSignUp(with: error.localizedDescription)
    }
    
    func succesSignIn() {
        self.view.signInSuccesed()
    }
    
    func failedSignIn(with error: Error) {
        self.view.signInFailed(with: error.localizedDescription)
    }
}
