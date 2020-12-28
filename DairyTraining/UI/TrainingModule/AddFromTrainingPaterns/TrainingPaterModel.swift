import Foundation

protocol TrainingPaterModelProtocol {
    var paterns: [TrainingPaternManagedObject] { get }
    
    func createTrainingPatern(with name: String)
    func removeTrainingPater(at index: Int)
    func pushTrainingPatern(at index: Int)
}


final class TrainingPaterModel {
    
    // MARK: - Properties
    private var dataManager = TrainingDataManager.shared
    weak var output: TrainingPaternViewModelInput?
    
    // MARK: - Initialization
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(trainingNameWasChanged),
                                               name: .paternNameWasChanged,
                                               object: nil)
    }
    
    // MARK: - Actions
    @objc private func trainingNameWasChanged() {
        output?.paternRenamed()
    }
}

// MARK: - TrainingPaterModelProtocol
extension TrainingPaterModel: TrainingPaterModelProtocol {
    
    var paterns: [TrainingPaternManagedObject] {
        dataManager.trainingPaterns
    }

    func pushTrainingPatern(at index: Int) {
        let choosenPatern = dataManager.trainingPaterns[index]
        MainCoordinator.shared.coordinate(to: TrainingModuleCoordinator.Target.choosenTrainingPatern(patern: choosenPatern))
    }

    func createTrainingPatern(with name: String) {
        dataManager.addTrainingPatern(with: name)
        output?.paternCreated()
    }
    
    func removeTrainingPater(at index: Int) {
        dataManager.removeTrainingPatern(at: index)
        output?.paternRemoved(at: index)
    }
}
