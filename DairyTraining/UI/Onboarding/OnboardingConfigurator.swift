import UIKit

final class OnboardingConfigurator {
    
    static func configureOnboardingFlow() -> UINavigationController {
        let viewModel = OnboardingPresenter()
        let view = OnboardingViewController(viewModel: viewModel)
        let router = OnboardingRouter(view)
        viewModel.router = router
        viewModel.view = view
        let flow = UINavigationController(rootViewController: view)
        flow.navigationBar.isHidden = true
        return flow
    }
}
