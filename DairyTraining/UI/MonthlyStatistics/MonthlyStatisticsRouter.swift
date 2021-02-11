//
//  MonthlyStatisticsRouter.swift
//  Dairy Training
//
//  Created by Вячеслав on 31.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit
protocol MonthlyStatisticsRouterProtocol {
    func popViewController()
}

final class MonthlyStatisticsRouter: Router {
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    
    private let rootViewController: UIViewController
    
    
}

extension MonthlyStatisticsRouter: MonthlyStatisticsRouterProtocol {
    
    func popViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
}
