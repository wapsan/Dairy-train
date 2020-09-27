import Foundation

protocol TrainingListStatisticsModelOutput: AnyObject {
    func setTrainingList(to trainingList: [TrainingManagedObject])
}

protocol TrainingListStatisticsModelIteracting: AnyObject {
    func getStatisticsModel()
}

final class TrainingListStatisticsModel {
    
    weak var output: TrainingListStatisticsModelOutput?
}

//MARK: - TrainingListStatisticsModelIteracting
extension TrainingListStatisticsModel: TrainingListStatisticsModelIteracting {
    
    func getStatisticsModel() {
        let trainiglist = CoreDataManager.shared.fetchTrainingList()
        self.output?.setTrainingList(to: trainiglist)
    }
}
