//
//  TrainingPaternRouter.swift
//  Dairy Training
//
//  Created by Вячеслав on 03.10.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import UIKit

final class TrainingPaternRouter: Router {
    
    private weak var rootViewController: TrainingPaternsViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? TrainingPaternsViewController
    }
    
    func pushMuscleGroupViewController(with patern: TrainingPaternManagedObject?) {
        let muscularGroupViewController = self.configureMuscleGroupViewController(with: .trainingPatern(trainingPatern: patern))
        self.rootViewController?.navigationController?.pushViewController(muscularGroupViewController, animated: true)
    }
    
    func pushChoosenPaternViewController(with choosenPatern: TrainingPaternManagedObject) {
        let choosenPaternViewController = self.configureChoosenPaternViewController(with: choosenPatern)
        rootViewController?.navigationController?.pushViewController(choosenPaternViewController, animated: true)
    }
}

private extension TrainingPaternRouter {
    
    func configureChoosenPaternViewController(with choosenPatern: TrainingPaternManagedObject) -> ChoosenPaternViewController {
        let choosenPaternModel = ChoosenPaternModel(patern: choosenPatern)
        let choosenPaternViewModel = ChoosenPaternViewModel(model: choosenPaternModel)
        let choosenPaternViewController = ChoosenPaternViewController(viewModel: choosenPaternViewModel)
        let choosenPaternRouter = ChoosenPaternRouter(choosenPaternViewController)
        choosenPaternViewModel.router = choosenPaternRouter
        return choosenPaternViewController
    }
    
    func configureMuscleGroupViewController(with trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupsVC = MuscleGroupsViewController(trainingEntityTarget: trainingEntityTarget)
        let muscleGroupsViewMode = MuscleGroupsViewModel()
        let muscleGroupsRouter = MuscleGroupsRouter(muscleGroupsVC)
        muscleGroupsVC.viewModel = muscleGroupsViewMode
        muscleGroupsVC.router = muscleGroupsRouter
        muscleGroupsViewMode.viewPresenter = muscleGroupsVC
        return muscleGroupsVC
    }
}
