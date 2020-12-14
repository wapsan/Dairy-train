//
//  SearchFoodModel.swift
//  Dairy Training
//
//  Created by cogniteq on 14.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import Foundation

protocol SearchFoodModelProtocol {
    func requestFood(for text: String)
}

final class SearchFoodModel {
    
    // MARK: - Module Properties
    weak var output: SearchFoodViewModellInput?
}

// MARK: - NutritionModelProtocol
extension SearchFoodModel: SearchFoodModelProtocol {
    
    func requestFood(for text: String) {
        NetworkManager.shared.requestNutritionInfo(for: text) { (response) in
            switch response {
            case .success(let responseModel):
                self.output?.foodListWasUpdated(to: responseModel.hints.map({ $0.food }))
            case .failure(_):
                print("Here")
            }
        }
    }
}
