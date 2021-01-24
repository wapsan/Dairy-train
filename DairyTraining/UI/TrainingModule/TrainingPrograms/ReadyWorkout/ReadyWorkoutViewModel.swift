import UIKit

protocol ReadyWorkoutViewModelProtocol {
    var exerciseCount: Int { get }
    var workoutTitle: String { get }
    var workoutDescription: String { get }
    var workoutImage: UIImage? { get }
    
    func viewDidLoad()
    func getExercise(for index: Int) -> Exercise
    func backButtonPressed()
    func createTrainingButtonPressed()
    func createPaternButtonPressed()
}

final class ReadyWorkoutViewModel {
    
    // MARK: - Module properties
    weak var view: ReadyWorkoutViewProtocol?
    var model: ReadyWorkoutModelProtocol
    var router: ReadyWotkoutRouterProtocol?
    
    // MARK: - Initialization
    init(model: ReadyWorkoutModelProtocol) {
        self.model =  model
    }
}

// MARK: - ReadyWorkoutViewModelProtocol
extension ReadyWorkoutViewModel: ReadyWorkoutViewModelProtocol {
    
    func backButtonPressed() {
        router?.popViewController()
    }
    
    func createTrainingButtonPressed() {
        model.createTraining()
    }
    
    func createPaternButtonPressed() {
        model.createPatern()
    }
    
    func viewDidLoad() {
        view?.showLoader()
        model.loadExercise()
    }
    
    var workoutImage: UIImage? {
        return model.workout.image
    }
    
    var workoutTitle: String {
        return model.workout.title
    }
    
    var workoutDescription: String {
        return model.workout.description
    }
    
    func getExercise(for index: Int) -> Exercise {
        return model.exercises[index]
    }
    
    var exerciseCount: Int {
        return model.exercises.count
    }
}

// MARK: - ReadyWorkoutModelOutput
extension ReadyWorkoutViewModel: ReadyWorkoutModelOutput {
    
    func paternCreated() {
        router?.showInfoAlert(with: "Workout patern created!")
    }
    
    func trainingCreated() {
        router?.showInfoAlert(with: "Workout created!")
    }
    
    func exercisesLoaded() {
        view?.hideLoader()
        view?.reloadData()
    }
}
