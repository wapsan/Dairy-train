import Foundation

protocol ChoosenPaternModelProtocol {
    var patern: WorkoutTemplateMO { get }
    
    var exercises: [ExerciseMO] { get }
    
    func createTrainingWithCurrentpatern(exercise: [Exercise])
    func renameTrainingPaternAlert(for name: String)
}

final class ChoosenPaternModel {
    
    //MARK: - Internal protperties
    weak var output: ChoosenPaternViewModelInput?
    
    //MARK: - Private properties
    private(set) var _trainingPatern: WorkoutTemplateMO
    private(set) var paternName: String
    private let persistenceService: PersistenceService
    
    private var _exercise: [ExerciseMO] = []
    
    //MARK: - Initialization
    init(patern: WorkoutTemplateMO, service: PersistenceService = PersistenceService()) {
        self.persistenceService = service
        self._trainingPatern = patern
        self.paternName = patern.name
        
        _exercise = service.workoutTemplates.fetchExercise(for: patern)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(exerciseWasAdedToPatern),
                                               name: .exerciseWasAdedToPatern,
                                               object: nil)
    }
    
    @objc private func exerciseWasAdedToPatern() {
        _exercise = persistenceService.workoutTemplates.fetchExercise(for: patern)
        output?.exerciseWasAdedTopatern()
    }
}

// MARK: - ChoosenPaternModelProtocol
extension ChoosenPaternModel: ChoosenPaternModelProtocol {
    
    var exercises: [ExerciseMO] {
        return _exercise
    }
    
    var patern: WorkoutTemplateMO {
        _trainingPatern
    }
    
    func createTrainingWithCurrentpatern(exercise: [Exercise]) {
        if persistenceService.workout.isTodayWorkoutExist {
            persistenceService.workout.addExerciseToTodaysWorkout(exercise: exercise)
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
        } else {
            persistenceService.workout.createWorkout(with: exercise)
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        }
    }
    
    func renameTrainingPaternAlert(for name: String) {
        _trainingPatern = persistenceService.workoutTemplates.renameWorkoutTemplae(workoutTemplate: _trainingPatern,
                                                                                   for: name)
        output?.paternNameChanged(to: name)
        NotificationCenter.default.post(name: .paternNameWasChanged, object: nil)
    }
}
