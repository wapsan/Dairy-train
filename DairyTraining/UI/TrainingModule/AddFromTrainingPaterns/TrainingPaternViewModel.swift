import Foundation

protocol TrainingPaternViewModelProtocol: PaternNamingAlertDelegate {
    var paterns: [TrainingPaternManagedObject] { get }
    
    func createTrainingPatern(with name: String)
    func removeTrainingPatern(at index: Int)
    func didSelectRow(at index: Int)
}

protocol TrainingPaternViewModelInput: AnyObject {
    func paternCreated()
    func paternRemoved(at index: Int)
    func paternRenamed()
}

final class TrainingPaternViewModel {
    
    //MARK: - Private properties
    private var model: TrainingPaterModelProtocol
    
    //MARK: - Properties
    weak var view: TrainingPaternsView?
    
    //MARK: - Initialization
    init(model: TrainingPaterModelProtocol) {
        self.model = model
    }
}

//MARK: - PaternNamingAlertDelegate
extension TrainingPaternViewModel {
    
    func patrnNamingAlertOkPressedToRenamePatern(name: String) {
        return
    }
    
    func paternNamingAlertOkPressedToCreatePatern(name: String) {
        createTrainingPatern(with: name)
    }
}

// MARK: - TrainingPaternViewModelProtocol
extension TrainingPaternViewModel: TrainingPaternViewModelProtocol {
    
    var paterns: [TrainingPaternManagedObject] {
        model.paterns.isEmpty ? view?.showEmtyLabel() : view?.showPaternsTable()
        return model.paterns
    }
    
    func didSelectRow(at index: Int) {
        model.pushTrainingPatern(at: index)
    }

    func createTrainingPatern(with name: String) {
        model.createTrainingPatern(with: name)
    }
    
    func removeTrainingPatern(at index: Int) {
        model.removeTrainingPater(at: index)
    }
}

// MARK: - TrainingPaternViewModelInput
extension TrainingPaternViewModel: TrainingPaternViewModelInput {
    
    func paternRenamed() {
        view?.reloadTable()
    }
    
    func paternRemoved(at index: Int) {
        view?.deleteCell(at: index)
    }
    
    func paternCreated() {
        view?.reloadTable()
    }
}
