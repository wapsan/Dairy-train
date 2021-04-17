import Foundation

protocol ReadyWorkoutModelProtocol {
    var exercises: [Exercise] { get }
    var workout: SpecialWorkout { get }
    
    func loadExercise()
    func createTraining()
    func createPatern()
}

protocol ReadyWorkoutModelOutput: AnyObject {
    func exercisesLoaded()
    func trainingCreated()
    func paternCreated()
}

final class ReadyWorkoutModel {
    
    // MARK: - Module properties
    weak var output: ReadyWorkoutModelOutput?
    
    // MARK: - Properties
    private lazy var firebaseStorageService = FirebaseStorageMnager()
    private let _workout: SpecialWorkout
    private var _exercises: [Exercise] = []
    private let persistenceService: PersistenceService
    
    // MARK: - Initialization
    init(workout: SpecialWorkout, service: PersistenceService = PersistenceService()) {
        self.persistenceService = service
        self._workout = workout
    }
}

// MARK: - ReadyWorkoutModelProtocol
extension ReadyWorkoutModel: ReadyWorkoutModelProtocol {
    
    func createTraining() {
        if persistenceService.workout.isTodayWorkoutExist {
            persistenceService.workout.addExerciseToTodaysWorkout(exercise: _exercises)
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
            
        } else {
            persistenceService.workout.createWorkout(with: _exercises)
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
            
        }
    }
    
    func createPatern() {
       // workoutTemplateService.addWorkoutTemplate(title: _workout.title, exercise: _exercises)
        output?.paternCreated()
    }
    
    func loadExercise() {
        firebaseStorageService.getListOfExercise(for: _workout) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?._exercises = data
                self?.output?.exercisesLoaded()
            case .failure(let _):
                print("Error to fetch exercises.")
            }
        }
    }
    
    var workout: SpecialWorkout {
        return _workout
    }
    
    var exercises: [Exercise] {
        return _exercises
    }
}
