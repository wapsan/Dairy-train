//
//  ReadyWorkoutViewModel.swift
//  Dairy Training
//
//  Created by cogniteq on 05.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import UIKit

protocol ReadyWorkoutViewModelProtocol {
    var exerciseCount: Int { get }
    var workoutTitle: String { get }
    var workoutDescription: String { get }
    var workoutImage: UIImage? { get }
    
    func getExercise(for index: Int) -> Exercise
}

final class ReadyWorkoutViewModel {
    
    weak var view: ReadyWorkoutViewProtocol?
    var model: ReadyWorkoutModelProtocol
    
    init(model: ReadyWorkoutModelProtocol) {
        self.model =  model
    }
}

extension ReadyWorkoutViewModel: ReadyWorkoutViewModelProtocol {
    
    var workoutImage: UIImage? {
        return model.workout.image
    }
    
    var workoutTitle: String {
        return model.workout.title
    }
    
    var workoutDescription: String {
        return model.workout.description
    }
    
    func getExercise(for index: Int) -> Exercise {
        return model.exercises[index]
    }
    
    var exerciseCount: Int {
        return model.exercises.count
    }
}

extension ReadyWorkoutViewModel: ReadyWorkoutModelOutput {
    
}
