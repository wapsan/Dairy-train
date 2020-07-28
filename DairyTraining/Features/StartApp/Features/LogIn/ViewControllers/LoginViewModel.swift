import UIKit

final class LoginViewModel {
    
    //MARK: - Properties
    var viewPresenter: LoginViewControllerPresenter!
    var model: LoginModel!
    
    //MARK: - Public methods
    func signIn(with email: String?, and password: String?) {
        self.model.signIn(with: email, and: password)
    }
    
    func signUp(with email: String?, and password: String?) {
        self.model.signUp(with: email, and: password)
    }
    
    func signInWithGoogle() {
        self.model.signInWithGoogle()
    }
    
    func setUpGooglePresentingViewController(to viewController: UIViewController) {
        self.model.setUpGooglePresentingViewController(to: viewController)
    }
}

//MARK: - LoginModelDelegate
extension LoginViewModel: LoginModelDelegate {
    
    func startSigninIn() {
        self.viewPresenter.startSigninIn()
    }
    
    func googleStartSignIn() {
        self.viewPresenter.googleSignInStart()
    }
    
    func succesSignUp() {
        self.viewPresenter.succesSignUp()
    }
    
    func failedSignUp(with error: Error) {
        self.viewPresenter.failedSignUp(with: error.localizedDescription)
    }
    
    func succesSignIn() {
        self.viewPresenter.signInSuccesed()
    }
    
    func failedSignIn(with error: Error) {
        self.viewPresenter.signInFailed(with: error.localizedDescription)
    }
}
