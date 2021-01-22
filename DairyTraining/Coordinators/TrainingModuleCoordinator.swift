import UIKit

final class TrainingModuleCoordinator: Coordinator {

    //MARK: - Constants
    private struct Constants {
    }
    
    // MARK: - Types
    enum Target: CoordinatorTarget {
        case choosenTraining(training: TrainingManagedObject)
        case statisticForCurrentTraining(training: TrainingManagedObject)
        case statisticsForChosenExercise(exercise: ExerciseManagedObject)
    }
    
    // MARK: - Properties
    var window: UIWindow?
    private var navigationController: UINavigationController?
    
    // MARK: - Init

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
    }
    
    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        guard let target = target as? Target else { return false }
        switch target {
        case .choosenTraining(training: let training):
            let choosenTrainingViewController = configureTrainingViewController(for: training)
            navigationController?.pushViewController(choosenTrainingViewController, animated: true)
        case .statisticsForChosenExercise(exercise: let exercise):
            let choosenExerciseForStatisticViewController = configureStatisticsViewController(exercise: exercise)
            topViewController?.present(choosenExerciseForStatisticViewController, animated: true, completion: nil)
        case .statisticForCurrentTraining(training: let training):
            let a = configureTVSModule(for: training)
            navigationController?.pushViewController(a, animated: true)
        }
        return true
    }

    // MARK: - Configuration methods
    private func configureTrainingViewController(for train: TrainingManagedObject) -> TrainingViewController {
        let trainingModel = TrainingModel(with: train)
        let trainingViewModel = TrainingViewModel(model: trainingModel)
        let trainingViewController = TrainingViewController(viewModel: trainingViewModel)
        trainingViewModel.view = trainingViewController
        trainingModel.output = trainingViewModel
        return trainingViewController
    }
    
    func configureTVSModule(for train: TrainingManagedObject) -> WorkoutStatisticsViewController {
        let statistics = Statistics(for: train)
        let choosenStatisticsViewModel = WorkoutStatisticsViewModel(statistics: statistics)
        let choosenStatisticsViewController = WorkoutStatisticsViewController(viewModel: choosenStatisticsViewModel)
        return choosenStatisticsViewController
    }

    private func configureStatisticsViewController(exercise: ExerciseManagedObject) -> ChoosenExerciseStatisticsViewController {
        let choosenExerciseForStatisticViewModel = ChoosenExerciseStatisticsViewModel(exercise: exercise)
        let choosenExerciseForStatisticViewController = ChoosenExerciseStatisticsViewController(viewModel: choosenExerciseForStatisticViewModel)
        return choosenExerciseForStatisticViewController
    }
}
