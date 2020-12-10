import Foundation

protocol TrainingListModelIteracting: AnyObject {
    func selectTraining(at index: Int)
    func deselectTraining(at index: Int)
    func deleteSelectedTraining()
    func deselectAllTraining()
}

protocol TrainigListModelOutput: AnyObject {
    func trainingListWasChanged()
    func trainingWasChanged()
    func chekTrainingForDeletingList(isEmty: Bool)
}

final class TrainingListModel {
    
    var output: TrainigListModelOutput?
    
    //MARK: - Properties
    private var trainingListForDeleting: [TrainingManagedObject] = [] {
        didSet {
            self.output?.chekTrainingForDeletingList(isEmty: self.trainingListForDeleting.isEmpty)
        }
    }
    private(set) var trainingList: [TrainingManagedObject] {
        didSet {
            self.output?.trainingListWasChanged()
        }
    }
    
    //MARK: - Initialization
    init() {
        self.trainingList = TrainingDataManager.shared.getTraingList()
        self.addObserversForTrainingChanging()
    }
    
    //MARK: - Private methods
    private func addObserversForTrainingChanging() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasChanged),
                                               name: .trainingWasChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingListWasChanged),
                                               name: .trainingListWasChanged,
                                               object: nil)
    }
    
    //MARK: - Actions
    @objc private func trainingListWasChanged() {
        self.trainingList = TrainingDataManager.shared.getTraingList()
    }
    
    @objc private func trainingWasChanged() {
        self.trainingList[0] = TrainingDataManager.shared.getTraingList()[0]
        self.output?.trainingWasChanged()
    }
}

//MARK: - TrainingListModelIteracting
extension TrainingListModel: TrainingListModelIteracting {
    
    func deselectAllTraining() {
        self.trainingListForDeleting = []
    }
    
    func deleteSelectedTraining() {
        TrainingDataManager.shared.removeChoosenTrainings(self.trainingListForDeleting)
        self.trainingList = TrainingDataManager.shared.getTraingList()
        self.trainingListForDeleting = []
        NotificationCenter.default.post(name: .trainingListWasChanged, object: nil, userInfo: nil)
    }
    
    func selectTraining(at index: Int) {
        let selectedTraining = self.trainingList[index]
        self.trainingListForDeleting.append(selectedTraining)
    }
    
    func deselectTraining(at index: Int) {
        let deselectTraining = self.trainingList[index]
        self.trainingListForDeleting = self.trainingListForDeleting.filter({ $0.date != deselectTraining.date })
    }
}
