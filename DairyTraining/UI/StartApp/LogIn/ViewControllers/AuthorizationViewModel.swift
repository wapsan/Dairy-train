import UIKit

protocol LoginViewModelProtocol {
    func signInWithGoogle()
    func signInWithFacebook()
    func signInWithApple()
}

final class AuthorizationViewModel {
    
    //MARK: - Properties
    weak var view: AuthorizationViewProtocol?
    var router: AuthorizationRouterProtocol?
    
    private let model: AuthorizationModelProtocol
    
    // MARK: - Initialization
    init(model: AuthorizationModelProtocol) {
        self.model = model
    }
}

//MARK: - LoginViewModelInput
extension AuthorizationViewModel: LoginViewModelProtocol {
    
    func signInWithFacebook() {
        model.signInWithFacebook()
    }
    
    func signInWithApple() {
        model.signInWithApple()
    }

    func signInWithGoogle() {
        self.model.signInWithGoogle()
    }
}

//MARK: - LoginModelDelegate
extension AuthorizationViewModel: LoginModelOutput {

    func googleStartSignIn() {
        self.view?.googleSignInStart()
    }
    
    func succesSignIn() {
        view?.signInSuccesed()
        router?.setMainTabBarToRootViewController()
    }
}
