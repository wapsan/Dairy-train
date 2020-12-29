import UIKit

final class TrainingModuleCoordinator: Coordinator {

    //MARK: - Constants
    private struct Constants {
    }
    
    // MARK: - Types
    enum Target: CoordinatorTarget {
        case choosenTraining(training: TrainingManagedObject)
        case statisticForCurrentTraining(training: TrainingManagedObject)
        case statisticsForChosenExercise(name: String, exerciseDate: Date?)
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
        case .statisticsForChosenExercise(name: let name, exerciseDate: let exerciseDate):
            let choosenExerciseForStatisticViewController = configureStatisticsViewController(with: name, and: exerciseDate)
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
    
    func configureTVSModule(for train: TrainingManagedObject) -> ChoosenTrainingStatisticsViewController {
        let statistics = Statistics(for: train)
        let choosenStatisticsViewModel = ChoosenTrainingStatisticsViewModel(statistics: statistics)
        let choosenStatisticsViewController = ChoosenTrainingStatisticsViewController(viewModel: choosenStatisticsViewModel)
        return choosenStatisticsViewController
    }

    private func configureStatisticsViewController(with exerciseName: String,
                                                   and exerciseDate: Date?) -> ChoosenExerciseStatisticsViewController {
        let choosenExerciseForStatisticViewModel = ChoosenExerciseStatisticsViewModel(exersiceName: exerciseName,
                                                                                      currentExerciseDate: exerciseDate)
        let choosenExerciseForStatisticViewController = ChoosenExerciseStatisticsViewController(viewModel: choosenExerciseForStatisticViewModel)
        return choosenExerciseForStatisticViewController
    }
}
