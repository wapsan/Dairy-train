import Foundation

protocol TrainingPaternViewModelProtocol: PaternNamingAlertDelegate, TitledScreenProtocol {
    var paternsCount: Int { get }
    var isPaternsExisting: Bool { get }
    var emptyPaternErrorMessage: String { get }
    
    func getPatern(for index: Int) -> WorkoutTemplateMO
    func closeButtonPressed()
    func createTrainingPatern(with name: String)
    func swipeRow(at index: Int)
    func didSelectRow(at index: Int)
}

protocol TrainingPaternViewModelInput: AnyObject {
    func paternCreated()
    func paternRemoved(at index: Int)
    func paternRenamed()
    func dataLoaded()
}

final class TrainingPaternViewModel {
    
    //MARK: - Private properties
    private let model: TrainingPaterModelProtocol
    
    //MARK: - Properties
    weak var view: TrainingPaternsView?
    var router: TrainingPaternsRouterProtocol?
    
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

    var emptyPaternErrorMessage: String {
        return "You have no created training patern yet."
    }
    
    func getPatern(for index: Int) -> WorkoutTemplateMO {
        return model.paterns[index]
    }
    
    var paternsCount: Int {
        return isPaternsExisting ? model.paterns.count : 1
    }
    
    var isPaternsExisting: Bool {
        return !model.paterns.isEmpty
    }
    
    func closeButtonPressed() {
        router?.closeTrainingPaternsFlow()
    }
    
    var title: String {
        return "Workout paterns"
    }
    
    var description: String {
        return "There are your workout paterns wich contains exercises set yor created by yorself"
    }
    

    func didSelectRow(at index: Int) {
        let choosenPatern = model.paterns[index]
        router?.showTrainingPaternScreen(for: choosenPatern)
    }

    func createTrainingPatern(with name: String) {
        model.createTrainingPatern(with: name)
    }
    
    func swipeRow(at index: Int) {
        model.removeTrainingPater(at: index)
    }
}

// MARK: - TrainingPaternViewModelInput
extension TrainingPaternViewModel: TrainingPaternViewModelInput {
    
    func dataLoaded() {
        view?.reloadTable()
    }
    
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
