import Foundation

protocol ReadyWorkoutModelProtocol {
    var exercises: [Exercise] { get }
    var workout: SpecialWorkout { get }
    
    func loadExercise()
    func popViewController()
    func createTraining()
    func createPatern()
    func dismisNavigationController()
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
    private var firebaseStorageService = FirebaseStorageMnager()
    private let _workout: SpecialWorkout
    private var _exercises: [Exercise] = []
    
    // MARK: - Initialization
    init(workout: SpecialWorkout) {
        self._workout = workout
    }
}

// MARK: - ReadyWorkoutModelProtocol
extension ReadyWorkoutModel: ReadyWorkoutModelProtocol {
    
    func dismisNavigationController() {
        MainCoordinator.shared.dismiss()
    }
    
    func popViewController() {
        MainCoordinator.shared.popViewController()
    }
    
    func createTraining() {
        if TrainingDataManager.shared.addExercisesToTrain(_exercises) {
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
            output?.trainingCreated()
        } else {
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
        }
    }
    
    func createPatern() {
        TrainingDataManager.shared.createTrainingPatern(wtih: _workout.title, and: _exercises)
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
