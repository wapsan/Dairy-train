import UIKit

struct AuthorizationConfigurator {
    
    static func configureAuthorizationViewController() -> AuthorizationViewController {
        let authorizationModel = AuthorizationModel()
        let authorizationViewModel = AuthorizationViewModel(model: authorizationModel)
        let authorizationViewController = AuthorizationViewController(viewModel: authorizationViewModel)
        authorizationModel.output = authorizationViewModel
        authorizationViewModel.view = authorizationViewController
        return authorizationViewController
    }
}
