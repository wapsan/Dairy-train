import UIKit

final class TrainingModuleCoordinator: Coordinator {

    //MARK: - Constants
    private struct Constants {
    }
    
    // MARK: - Types
    enum Target: CoordinatorTarget {
        case choosenTraining(training: TrainingManagedObject)
        case trainingPaternsList
        case choosenTrainingPatern(patern: TrainingPaternManagedObject)
        case muscularGrops(target: TrainingEntityTarget)
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
        case .trainingPaternsList:
            let trainingPaternsList = configureTrainingPaternsViewController()
            navigationController?.pushViewController(trainingPaternsList, animated: true)
        case .choosenTrainingPatern(let patern):
            let choosenPaternViewController = configureChoosenPaternViewController(with: patern)
            navigationController?.pushViewController(choosenPaternViewController, animated: true)
        case .muscularGrops(target: let target):
            let muscleGroupViewController = configureMuscleVC(with: target)
            topViewController?.present(muscleGroupViewController, animated: true, completion: nil)
        case .statisticsForChosenExercise(name: let name, exerciseDate: let exerciseDate):
            let choosenExerciseForStatisticViewController = configureStatisticsViewController(with: name, and: exerciseDate)
            topViewController?.present(choosenExerciseForStatisticViewController, animated: true, completion: nil)
        }
        return true
    }

    // MARK: - Configuration methods
    private func configureTrainingViewController(for train: TrainingManagedObject) -> TrainingViewController {
        let trainingViewController = TrainingViewController()
        let trainingViewModel = TrainingViewModel()
        let trainingModel = TrainingModel(with: train)
        let trainingRouter = TrainingRouter(trainingViewController)
        trainingViewController.viewModel = trainingViewModel
        trainingViewModel.router = trainingRouter
        trainingViewModel.view = trainingViewController
        trainingViewModel.model = trainingModel
        trainingModel.output = trainingViewModel
        return trainingViewController
    }
    
    private func configureTrainingPaternsViewController() -> TrainingPaternsViewController {
        let trainingPaternModel = TrainingPaterModel()
        let trainingPaternViewModel = TrainingPaternViewModel(model: trainingPaternModel)
        let trainingPaternsViewController = TrainingPaternsViewController(viewModel: trainingPaternViewModel)
        let trainingPaternRouter = TrainingPaternRouter(trainingPaternsViewController)
        trainingPaternViewModel.router = trainingPaternRouter
        return trainingPaternsViewController
    }
    
    private func configureMuscleVC(with trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupsVC = MuscleGroupsViewController(trainingEntityTarget: trainingEntityTarget)
           return muscleGroupsVC
       }
    
    private func configureChoosenPaternViewController(with choosenPatern: TrainingPaternManagedObject) -> ChoosenPaternViewController {
        let choosenPaternModel = ChoosenPaternModel(patern: choosenPatern)
        let choosenPaternViewModel = ChoosenPaternViewModel(model: choosenPaternModel)
        let choosenPaternViewController = ChoosenPaternViewController(viewModel: choosenPaternViewModel)
        return choosenPaternViewController
    }
    
    private func configureStatisticsViewController(with exerciseName: String,
                                                   and exerciseDate: Date?) -> ChoosenExerciseStatisticsViewController {
        let choosenExerciseForStatisticViewModel = ChoosenExerciseStatisticsViewModel(exersiceName: exerciseName,
                                                                                      currentExerciseDate: exerciseDate)
        let choosenExerciseForStatisticViewController = ChoosenExerciseStatisticsViewController(viewModel: choosenExerciseForStatisticViewModel)
        return choosenExerciseForStatisticViewController
    }
}
