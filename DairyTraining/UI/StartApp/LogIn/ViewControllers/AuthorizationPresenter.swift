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
    private let interactor: AuthorizationInteractorProtocol
    
    // MARK: - Initialization
    init(interactor: AuthorizationInteractorProtocol) {
        self.interactor = interactor
    }
}

//MARK: - LoginViewModelInput
extension AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    func signInWithFacebook() {
        interactor.signInWithFacebook()
    }
    
    func signInWithApple() {
        interactor.signInWithApple()
    }

    func signInWithGoogle() {
        self.interactor.signInWithGoogle()
    }
}

//MARK: - LoginModelDelegate
extension AuthorizationPresenter: AuthorizationInteractorOutput {
    
    func failureSignIn() {
        view?.signInFailure()
    }
    
    func googleStartSignIn() {
        view?.googleSignInStart()
    }
    
    func succesSignIn() {
        view?.signInSuccesed()
        router?.setMainTabBarToRootViewController()
    }
}
