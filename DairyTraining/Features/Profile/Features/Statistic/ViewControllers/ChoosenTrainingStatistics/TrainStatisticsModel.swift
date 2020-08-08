import Foundation

protocol TrainStatisticsModelOutput: AnyObject {
    func setStatistics(for statistics: Statistics)
    func setTrainigDate(for date: String?)
    func reloadTrainingStatistics()
}

final class TrainStatisticsModel {
    
    var statistics: Statistics
    var trainingDate: String?
    weak var output: TrainStatisticsModelOutput?
    
    init(train: TrainingManagedObject) {
        self.statistics = Statistics(for: train)
        self.trainingDate = train.formatedDate
        self.addObserverForTrainigChanged()
    }
    
    func loadStaistic() {
        self.output?.setStatistics(for: self.statistics)
        self.output?.setTrainigDate(for: self.trainingDate)
    }
    
    private func addObserverForTrainigChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasChanged(_:)),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    @objc private func trainingWasChanged(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let train = userInfo["Train"] as? TrainingManagedObject else { return }
        self.statistics = Statistics(for: train)
        self.trainingDate = train.formatedDate
        self.output?.setStatistics(for: self.statistics)
        self.output?.setTrainigDate(for: self.trainingDate)
        self.output?.reloadTrainingStatistics()
    }
}
