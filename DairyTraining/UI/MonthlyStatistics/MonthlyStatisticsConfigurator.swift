//
//  MonthlyStatisticsConfigurator.swift
//  Dairy Training
//
//  Created by Вячеслав on 31.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

final class MonthlyStatisticsConfigurator {
    
    static func configureScreen() -> MonthlyStatisticsViewController {
        let model = MonthlyStatisticsModel()
        let viewModel = MonthlyStatisticsViewModel(model: model)
        let view = MonthlyStatisticsViewController(viewModel: viewModel)
        let router = MonthlyStatisticsRouter(view)
        viewModel.view = view
        viewModel.router = router
        return view
    }
}
 
