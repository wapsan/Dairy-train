import UIKit

protocol WorkoutRouterProtocol  {
    func showCurrentWorkoutStatisticsScreen(for workout: WorkoutMO)
    func showExerciseHistoryStatisticsScreen(for exercise: ExerciseMO)
    func popViewController()
    func presentExerciseFlow()
    
    func showAlert(title: String?, message: String?, completion: @escaping () -> Void)
}

final class WorkoutRouter: Router {
    
    // MARK: - Private properties
    private weak var rootViewController: UIViewController?
    
    // MARK: - Init
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
}

// MARK: - WorkoutRouterProtocol
extension WorkoutRouter: WorkoutRouterProtocol {
    
    func showAlert(title: String?, message: String?, completion: @escaping () -> Void) {
        showAlertWithCompletion(title: title, message: message, alertType: .alert, completion: completion)
    }
    
    func presentExerciseFlow() {
        let muscleGroupViewController = MuscleGroupsViewControllerConfigurator().configure(for: .training)
        let navigationController = UINavigationController(rootViewController: muscleGroupViewController)
        navigationController.modalPresentationStyle = .fullScreen
        mainTabBar?.present(navigationController, animated: true, completion: nil)
    }
    
    func popViewController() {
        rootViewController?.navigationController?.popViewController(animated: true)
    }

    func showCurrentWorkoutStatisticsScreen(for workout: WorkoutMO) {
        let workoutStatisticsViewController = WorkoutStatisticsConfigurator.configure(for: workout)
        rootViewController?.navigationController?.pushViewController(workoutStatisticsViewController, animated: true)
    }
    
    func showExerciseHistoryStatisticsScreen(for exercise: ExerciseMO) {
        let exerciseStatisticsViewController = ExerciseStatisticsConfigurator.configure(for: exercise)
        rootViewController?.present(exerciseStatisticsViewController, animated: true, completion: nil)
    }
}
