import Foundation

protocol TrainingListStatisticsViewModelInput: AnyObject {
    func loadStatisticsList()
    var trainigList: [TrainingManagedObject] { get set }
}

final class TrainingListStatisticsViewModel {
    
    var model: TrainingListStatisticsModelIteracting?
    private var _trainigList: [TrainingManagedObject] = []
}

//MARK: - TrainingListStatisticsViewModelInput
extension TrainingListStatisticsViewModel: TrainingListStatisticsViewModelInput {
    
    var trainigList: [TrainingManagedObject] {
        get {
            return self._trainigList
        }
        set {
            self._trainigList = newValue
        }
    }
    
    func loadStatisticsList() {
        self.model?.getStatisticsModel()
    }
}

//MARK: - TrainingListStatisticsModelOutput
extension TrainingListStatisticsViewModel: TrainingListStatisticsModelOutput {
    
    func setTrainingList(to trainingList: [TrainingManagedObject]) {
        self.trainigList = trainingList
    }
}
