import Foundation

final class ChoosenTrainingStatisticsViewModel {
    
//    var model: ChoosenTrainingStatisticsModelIteracting?
//    private(set) var statistic: Statistics?
//    private(set) var trainingDate: String?
//
//    func loadStatistics() {
//        self.model?.loadStatistics()
//    }
    var statistics: Statistics
    init(statistics: Statistics) {
        self.statistics = statistics
    }
    
}

////MARK: - ChoosenTrainingStatisticsModelOutput
//extension ChoosenTrainingStatisticsViewModel: ChoosenTrainingStatisticsModelOutput {
//
//    func setStatistic(to statistics: Statistics) {
//        self.statistic = statistics
//    }
//
//    func setTrainigDate(to date: String?) {
//        self.trainingDate = date
//    }
//}
