import UIKit

protocol AuthorizationPresenterProtocol {
    func signInWithGoogle()
    func signInWithFacebook()
    func signInWithApple()
}

final class AuthorizationPresenter {
    
    //MARK: - Internal properties
    weak var view: AuthorizationViewProtocol?
    var router: AuthorizationRouterProtocol?
    
    //MARK: - Private properties
    private let model: AuthorizationInteractorProtocol
    
    // MARK: - Initialization
    init(model: AuthorizationInteractorProtocol) {
        self.model = model
    }
}

//MARK: - LoginViewModelInput
extension AuthorizationPresenter: AuthorizationPresenterProtocol {
    
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
extension AuthorizationPresenter: AuthorizationInteractorOutput {

    func googleStartSignIn() {
        self.view?.googleSignInStart()
    }
    
    func succesSignIn() {
        view?.signInSuccesed()
        router?.setMainTabBarToRootViewController()
    }
}
