//
//  CreatingTrainingModalModel.swift
//  Dairy Training
//
//  Created by cogniteq on 22.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

protocol CreatingTrainingModalModelProtocol {
    
}

final class CreatingTrainingModalModel {
    
    enum Option: String, CaseIterable {
        case fromExerciseList = "Exercise"
        case fromTrainingPatern = "Paterns"
        case fromSpecialTraining = "Special training"
        
        var title: String {
            return self.rawValue
        }
        
        var image: UIImage? {
            switch self {
            case .fromExerciseList:
                return UIImage(named: "avareProjectileWeightBackground")
            case .fromTrainingPatern:
                return UIImage(named: "avareProjectileWeightBackground")
            case .fromSpecialTraining:
                return UIImage(named: "avareProjectileWeightBackground")
            }
        }
        
        func onAction() {
            switch self {
            case .fromExerciseList:
                MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .training))
            case .fromTrainingPatern:
                MainCoordinator.shared.coordinate(to: TrainingPaternsCoordinator.Target.trainingPaternsList)
            case .fromSpecialTraining:
                MainCoordinator.shared.coordinate(to: TrainingProgramsCoordinator.Target.trainingLevels)
            }
        }
    }
}

extension CreatingTrainingModalModel: CreatingTrainingModalModelProtocol {
    
}
