import Foundation

protocol ChoosenPaternModelProtocol {
    var patern: TrainingPaternManagedObject { get }
    
    func createTrainingWithCurrentpatern(exercise: [Exercise])
    func renameTrainingPaternAlert(for name: String)
}

final class ChoosenPaternModel {
    
    private var dataManager = TrainingDataManager.shared
    weak var output: ChoosenPaternViewModelInput?
    private(set) var _trainingPatern: TrainingPaternManagedObject
    private(set) var paternName: String

    init(patern: TrainingPaternManagedObject) {
        self._trainingPatern = patern
        self.paternName = patern.name
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(exerciseWasAdedToPatern),
                                               name: .exerciseWasAdedToPatern,
                                               object: nil)
    }
    
    @objc private func exerciseWasAdedToPatern() {
        output?.exerciseWasAdedTopatern()
    }
}

// MARK: - ChoosenPaternModelProtocol
extension ChoosenPaternModel: ChoosenPaternModelProtocol {
    
    var patern: TrainingPaternManagedObject {
        _trainingPatern
    }
    
    func createTrainingWithCurrentpatern(exercise: [Exercise]) {
        if dataManager.addExercisesToTrain(exercise) {
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        } else {
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
        }
    }
    
    func renameTrainingPaternAlert(for name: String) {
        dataManager.renameTrainingPatern(with: _trainingPatern.date, with: name)
        output?.paternNameChanged(to: name)
        NotificationCenter.default.post(name: .paternNameWasChanged, object: nil)
    }
}
