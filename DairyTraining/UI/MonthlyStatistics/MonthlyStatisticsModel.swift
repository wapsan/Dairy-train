

import Foundation


protocol MonthlyStatisticsModelProtocol {
    var statisticsTypes: [MonthlyStatisticsModel.StatisticsItem] { get }
    func getStatisticsEntity(for index: Int) -> MonthlyStatisticsModel.Entity
}

protocol MonthlyStatisticsModelOutput: AnyObject {
   
}

final class MonthlyStatisticsModel {
    
    
    private let persistenceService: PersistenceService
    
    init(persistenceService: PersistenceService = PersistenceService()) {
        self.persistenceService = persistenceService
    }
}

//MARK: - MonthlyStatisticsModelProtocol
extension MonthlyStatisticsModel: MonthlyStatisticsModelProtocol {
    
    func getStatisticsEntity(for index: Int) -> Entity {
        let statisticType = StatisticsItem.allCases[index]
        let monthlyWorkouts = persistenceService.workout.fetchWorkouts(for: .mounth)
        let entity = statisticType.calculateValue(monthlyWorkouts: monthlyWorkouts)
        return entity
        
    }
    
    var statisticsTypes: [StatisticsItem] {
        return StatisticsItem.allCases
    }
}
