//
//  ReadyWorkoutModel.swift
//  Dairy Training
//
//  Created by cogniteq on 05.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import Foundation

protocol ReadyWorkoutModelProtocol {
    var exercises: [Exercise] { get }
    var workout: SpecialWorkout { get }
}

protocol ReadyWorkoutModelOutput: AnyObject {
    
}

final class ReadyWorkoutModel {
    weak var output: ReadyWorkoutModelOutput?
    
    private let _workout: SpecialWorkout
    private let _exercises: [Exercise]
    
    init(workout: SpecialWorkout, exercises: [Exercise]) {
        self._workout = workout
        self._exercises = exercises
    }
}


extension ReadyWorkoutModel: ReadyWorkoutModelProtocol {
    
    var workout: SpecialWorkout {
        return _workout
    }
    
    var exercises: [Exercise] {
        return _exercises
    }
}
