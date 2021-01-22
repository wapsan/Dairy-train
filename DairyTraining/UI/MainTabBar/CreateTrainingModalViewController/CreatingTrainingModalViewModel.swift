//
//  CreatingTrainingModalViewModel.swift
//  Dairy Training
//
//  Created by cogniteq on 22.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import Foundation

protocol CreatingTrainingModalViewModelProtocol {
    
}


final class CreatingTrainingModalViewModel {
    
    private let model: CreatingTrainingModalModelProtocol
    var router: CreatingTrainingModelRouterProtocol?
    
    init(model: CreatingTrainingModalModelProtocol) {
        self.model = model
    }
}
 
extension CreatingTrainingModalViewModel: CreatingTrainingModalViewModelProtocol {
    
}
