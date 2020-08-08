import Foundation

final class TrainStatisticsViewModel {
    
    //MARK: - Properties
    var trainingDate: String?
    var totalWorkoutWeight: String?
    var totalReps: String?
    var totalAproach: String?
    var avaragePorjectioleWeight: String?
    var tainedSubgroupList: [MuscleSubgroup.Subgroup] = []
    
    var model: TrainStatisticsModel?
    weak var view: TrainStatisticsViewController?
    
    func loadStatistcis() {
        self.model?.loadStaistic()
    }
}

//MARK: - TrainStatisticsModelOutput 
extension TrainStatisticsViewModel: TrainStatisticsModelOutput {
    
    func reloadTrainingStatistics() {
        self.view?.setUI()
    }
    
    func setTrainigDate(for date: String?) {
        self.trainingDate = date
    }

    func setStatistics(for statistics: Statistics) {
        self.totalWorkoutWeight = statistics.totalWorkoutWeight
        self.totalReps = statistics.totalNumberOfReps
        self.totalAproach = statistics.totalNumberOfAproach
        self.avaragePorjectioleWeight = statistics.averageProjectileWeight
        self.tainedSubgroupList = statistics.trainedSubGroupsList
    }
}
