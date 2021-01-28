//
//  OnboardingConfigurator.swift
//  Dairy Training
//
//  Created by Вячеслав on 27.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

final class OnboardingConfigurator {
    
    static func configureOnboardingFlow() -> UINavigationController {
        let viewModel = OnboardingViewModel()
        let view = OnboardingViewController(viewModel: viewModel)
        let router = OnboardingRouter(view)
        viewModel.router = router
        viewModel.view = view
        let flow = UINavigationController(rootViewController: view)
        flow.navigationBar.isHidden = true
        return flow
    }
}
