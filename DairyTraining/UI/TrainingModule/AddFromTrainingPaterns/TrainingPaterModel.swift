import Foundation

protocol TrainingPaterModelProtocol {
    var paterns: [TrainingPaternManagedObject] { get }
    
    func createTrainingPatern(with name: String)
    func removeTrainingPater(at index: Int)
    func pushTrainingPatern(at index: Int)
    func closeViewController()
}


final class TrainingPaterModel {
    
    // MARK: - Properties
    private let dataManager = TrainingDataManager.shared
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

    func closeViewController() {
        MainCoordinator.shared.dismiss()
    }
    
    var paterns: [TrainingPaternManagedObject] {
        return dataManager.trainingPaterns
    }

    func pushTrainingPatern(at index: Int) {
        let choosenPatern = dataManager.trainingPaterns[index]
        MainCoordinator.shared.coordinate(to: TrainingPaternsCoordinator.Target.paternScreen(trainingPatern: choosenPatern))
    }

    func createTrainingPatern(with name: String) {
        dataManager.addTrainingPatern(with: name)
        output?.paternCreated()
    }
    
    func removeTrainingPater(at index: Int) {
        dataManager.removeTrainingPatern(at: index)
        dataManager.trainingPaterns.isEmpty ? output?.dataLoaded() : output?.paternRemoved(at: index)
    }
}
