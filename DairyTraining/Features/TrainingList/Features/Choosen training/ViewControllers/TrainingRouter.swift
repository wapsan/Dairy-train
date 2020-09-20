//
//  TrainingRouter.swift
//  Dairy Training
//
//  Created by Вячеслав on 20.09.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

final class TrainingRouter: Router {
    
    weak var rootViewController: TrainingViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? TrainingViewController
    }
}
