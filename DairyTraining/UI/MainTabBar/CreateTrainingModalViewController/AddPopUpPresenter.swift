//
//  CreatingTrainingModalViewModel.swift
//  Dairy Training
//
//  Created by cogniteq on 22.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import Foundation

protocol AddPopUpPresenterProtocol {
    func numerOfRow(in section: Int) -> Int
    
    func didSelectRow(at indexPath: IndexPath)
    func option(at indexPath: IndexPath) -> AddPopUpInteractor.Option
}

final class AddPopUpPresenter {
    
    private let interactor: AddPopUpInteractorProtocol
    var router: AddPopUpRouterProtocol?
    
    init(interactor: AddPopUpInteractorProtocol) {
        self.interactor = interactor
    }
}
 
extension AddPopUpPresenter: AddPopUpPresenterProtocol {
    
    func numerOfRow(in section: Int) -> Int {
        return interactor.options.count
    }
    
    func option(at indexPath: IndexPath) -> AddPopUpInteractor.Option {
        return interactor.options[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let selectedOption = interactor.options[indexPath.row]
        router?.showScreen(for: selectedOption)
    }
}
