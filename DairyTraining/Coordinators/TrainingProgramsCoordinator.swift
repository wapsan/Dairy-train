import UIKit

final class TrainingProgramsCoordinator: Coordinator {

    // MARK: - Types
    enum Target: CoordinatorTarget {
        case trainingLevels
        case trainings(levelOfTrainings: LevelOfTrainingModel)
        case workout(workout: SpecialWorkout, exercises: [Exercise])
    }
    
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - Private properties
    private var navigationController: UINavigationController?
    
    // MARK: - Init
    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }

    // MARK: - Public methods
    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        
        case .trainingLevels:
            let trainingLevelsScreen = TrainingProgramsLevelsConfigurator.configure()
            let navigationController = UINavigationController(rootViewController: trainingLevelsScreen)
            navigationController.modalPresentationStyle = .overFullScreen
            
            self.navigationController = navigationController
            self.topViewController?.present(navigationController, animated: true, completion: nil)
            
        case .trainings(levelOfTrainings: let levelOfTrainings):
            let trainingsScreen = TrainingProgramsConfigurator.configure(for: levelOfTrainings)
            self.navigationController?.pushViewController(trainingsScreen, animated: true)
            
        case .workout(workout: let workout, exercises: let exercises):
            let workoutScreeConfigurator = ReadyWorkoutConfigurator()
            let workoutScreen = workoutScreeConfigurator.configureReadyWorkout(for: workout, and: exercises)
            self.navigationController?.pushViewController(workoutScreen, animated: true)
        }
        return true
    }
}
