import Foundation

protocol TrainingPaterModelProtocol {
    var paterns: [WorkoutTemplateMO] { get }
    
    func createTrainingPatern(with name: String)
    func removeTrainingPater(at index: Int)
}


final class TrainingPaterModel {
    
    // MARK: - Internal properties
    weak var output: TrainingPaternViewModelInput?
    
    //MARK: - Private properties
    private let persistanceService: PersistenceService
    private var _templates: [WorkoutTemplateMO] = []
    
    // MARK: - Initialization
    init(persistanceService: PersistenceService = PersistenceService()) {
        self.persistanceService = persistanceService
        _templates = persistanceService.workoutTemplates.getWorkoutsTemplates()
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

    var paterns: [WorkoutTemplateMO] {
        return _templates
    }

    func createTrainingPatern(with name: String) {
        let newPatern =  persistanceService.workoutTemplates.addWorkoutTemplate(title: name)
        _templates.append(newPatern)
        output?.paternCreated()
    }
    
    func removeTrainingPater(at index: Int) {
        let workouTemplate = _templates[index]
        _templates.remove(at: index)
        persistanceService.workoutTemplates.deleteWorkoutTemplate(workoutTemplate: workouTemplate)
        
        let actualTemplatesList = persistanceService.workoutTemplates.getWorkoutsTemplates()
        actualTemplatesList.isEmpty ? output?.dataLoaded() : output?.paternRemoved(at: index)
    }
}
