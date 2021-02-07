//
//  MonthlyStatisticsViewModel.swift
//  Dairy Training
//
//  Created by Вячеслав on 31.01.2021.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import Foundation

protocol MonthlyStatisticsViewModelProtocol: TitledScreenProtocol {
    var itemCount: Int { get }
    
    func getItem(for indexPath: IndexPath) -> MonthlyStatisticsModel.StatisticsItem
    func backButtonPressed()
}


final class MonthlyStatisticsViewModel {
    
    let model: MonthlyStatisticsModelProtocol
    weak var view: MonthlyStatisticsViewProtocol?
    var router: MonthlyStatisticsRouterProtocol?
    
    
    init(model: MonthlyStatisticsModelProtocol) {
        self.model = model
    }
    
}

extension MonthlyStatisticsViewModel: MonthlyStatisticsViewModelProtocol {
    
    func getItem(for indexPath: IndexPath) -> MonthlyStatisticsModel.StatisticsItem {
        return MonthlyStatisticsModel.StatisticsItem.allCases[indexPath.row]
    }
    
    var itemCount: Int {
        return MonthlyStatisticsModel.StatisticsItem.allCases.count
    }
    
    func backButtonPressed() {
        router?.popViewController()
    }
    
    var title: String {
        "Monthly statistics"
    }
    
    var description: String {
        "Here is you monthly statistics for current mounth."
    }
}
