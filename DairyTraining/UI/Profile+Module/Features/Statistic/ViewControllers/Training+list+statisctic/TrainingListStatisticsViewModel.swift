import Foundation

protocol TrainingListStatisticsViewModelInput: AnyObject {
    func trainigWasSelected(at index: Int)
    
    var trainigList: [TrainingManagedObject] { get }
}

final class TrainingListStatisticsViewModel {
    
    var model: TrainingListStatisticsModel
    private var _trainigList: [TrainingManagedObject] = []
    
    init(model: TrainingListStatisticsModel) {
        self.model = model
    }
}

//MARK: - TrainingListStatisticsViewModelInput
extension TrainingListStatisticsViewModel: TrainingListStatisticsViewModelInput {
   
    func trainigWasSelected(at index: Int) {
        let trainingStatistics = Statistics(for: trainigList[index])
        MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.statisticForChoosenTraining(statistics: trainingStatistics))
    }
    
    var trainigList: [TrainingManagedObject] {
        model.traingList
    }
}
