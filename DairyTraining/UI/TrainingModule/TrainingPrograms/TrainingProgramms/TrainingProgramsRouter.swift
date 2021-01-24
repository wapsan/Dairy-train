//
//  TrainingProgramsRouter.swift
//  Dairy Training
//
//  Created by Вячеслав on 24.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

protocol TrainingProgramsRouterProtocol {
    func showWorkoutScreen(for specialWorkout: SpecialWorkout)
    func popViewController()
}

final class TrainingProgramsRouter: Router {
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    private let rootViewController: UIViewController
    
    
    
}

extension TrainingProgramsRouter: TrainingProgramsRouterProtocol {
    
    func showWorkoutScreen(for specialWorkout: SpecialWorkout) {
        let readyWorkoutViewController = ReadyWorkoutConfigurator.configure(for: specialWorkout)
        rootViewController.navigationController?.pushViewController(readyWorkoutViewController,
                                                                    animated: true)
        
    }
    
    func popViewController() {
        rootViewController.navigationController?.popViewController(animated: true)
    }
    
    
}
