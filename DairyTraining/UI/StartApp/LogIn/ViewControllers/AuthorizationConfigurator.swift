import UIKit

struct AuthorizationConfigurator {
    
    static func configureAuthorizationViewController() -> AuthorizationViewController {
        let authorizationModel = AuthorizationModel()
        let authorizationViewModel = AuthorizationViewModel(model: authorizationModel)
        let authorizationViewController = AuthorizationViewController(viewModel: authorizationViewModel)
        let authorizationRouter = AuthorizationRouter(authorizationViewController)
        authorizationModel.output = authorizationViewModel
        authorizationViewModel.view = authorizationViewController
        authorizationViewModel.router = authorizationRouter
        return authorizationViewController
    }
}
