import Foundation

protocol ChoosenTrainingStatisticsModelIteracting: AnyObject {
    func loadStatistics()
}

protocol ChoosenTrainingStatisticsModelOutput: AnyObject {
    func setStatistic(to statistics: Statistics)
}

final class ChoosenTrainingStatisticsModel {
    
    private var train: TrainingManagedObject
    weak var output: ChoosenTrainingStatisticsModelOutput?
    
    init(_ train: TrainingManagedObject) {
        self.train = train
    }
}

//MARK: - ChoosenTrainingStatisticsModelIteracting
extension ChoosenTrainingStatisticsModel: ChoosenTrainingStatisticsModelIteracting{
    
    func loadStatistics() {
        let statisics = Statistics(for: self.train)
        self.output?.setStatistic(to: statisics)
    }
}
