//
//  SearchFoodViewModel.swift
//  Dairy Training
//
//  Created by cogniteq on 14.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//
import Foundation

protocol SearchFoodViewModelProtocol {
    var foodList: [Food] { get }
    func requestFood(for text: String)
}

protocol SearchFoodViewModellInput: AnyObject {
    func foodListWasUpdated(to foodList: [Food])
}

final class SearchFoodViewModel {
    
    // MARK: - Module properties
    weak var view: SearchFoodView?
    
    // MARK: - Private Properties
    private var model: SearchFoodModelProtocol
    private var _foodList: [Food] = [] {
        didSet {
            view?.reloadFoodList()
        }
    }
    
    // MARK: - Initialization
    init(model: SearchFoodModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionViewModelProtocol
extension SearchFoodViewModel: SearchFoodViewModelProtocol {
    
    var foodList: [Food] {
        return _foodList
    }
    
    func requestFood(for text: String) {
        model.requestFood(for: text)
    }
}

// MARK: - NutritionViewModelInput
extension SearchFoodViewModel: SearchFoodViewModellInput {
    
    func foodListWasUpdated(to foodList: [Food]) {
        self._foodList = foodList
    }
}
