import UIKit

struct AuthorizationConfigurator {
    
    static func configureAuthorizationViewController() -> AuthorizationViewController {
        let interactor = AuthorizationInteractor()
        let presenter = AuthorizationPresenter(interactor: interactor)
        let viewController = AuthorizationViewController(presenter: presenter)
        let router = AuthorizationRouter(viewController)
        interactor.output = presenter
        presenter.view = viewController
        presenter.router = router
        return viewController
    }
}
