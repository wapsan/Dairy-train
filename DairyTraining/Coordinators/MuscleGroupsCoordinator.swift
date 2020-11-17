
import UIKit

final class MuscleGroupsCoordinator: Coordinator {

    // MARK: - Types

    enum Target: CoordinatorTarget {
        case muscularGrops(patern: TrainingEntityTarget)
        case muscularSubgroups(patern: TrainingEntityTarget, muscleGroup: MuscleGroup.Group)
        case exercises(patern: TrainingEntityTarget, miscleSubgroups: MuscleSubgroup.Subgroup)
        case choosenExercise(name: String)
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
        case .muscularGrops(let trainingEntityTarget):
            let navigationController = UINavigationController(rootViewController: configureMuscleGroupViewController(with: trainingEntityTarget))
            navigationController.modalPresentationStyle = .fullScreen
            window?.rootViewController?.present(navigationController, animated: true, completion: nil)
            self.navigationController = navigationController
        case .muscularSubgroups(let trainingTartget, let muscleGroup):
            let muscleSubgroupViewController = configureMuscleSubgroupsViewController(with: muscleGroup, target: trainingTartget)
            navigationController?.pushViewController(muscleSubgroupViewController, animated: true)
        case .exercises(let patern, let muscleSubgroups):
            let exerciseListViewController = configureExerciseViewController(with: muscleSubgroups, target: patern)
            navigationController?.pushViewController(exerciseListViewController, animated: true)
        case .choosenExercise(let name):
            let choosenExerciseForStatisticViewModel = ChoosenExerciseStatisticsViewModel(exersiceName: name)
            let choosenExerciseForStatisticViewController = ChoosenExerciseStatisticsViewController(viewModel: choosenExerciseForStatisticViewModel)
            navigationController?.pushViewController(choosenExerciseForStatisticViewController, animated: true)
        }
        return true
    }
    
    
    // MARK: - Configuration methods
    private func configureMuscleGroupViewController(with trainingEntityTarget: TrainingEntityTarget) -> MuscleGroupsViewController {
        let muscleGroupViewController = MuscleGroupsViewController(trainingEntityTarget: trainingEntityTarget)
        let muscleGroupViewModel = MuscleGroupsViewModel()
        muscleGroupViewController.viewModel = muscleGroupViewModel
        return muscleGroupViewController
    }
    
    
    
    private func configureMuscleSubgroupsViewController(with muscleGroup: MuscleGroup.Group, target: TrainingEntityTarget) -> MuscleSubgroupsViewController {
        let subgroup = MuscleSubgroup(for: muscleGroup)
        let subGroupViewModel = MuscleSubgropsViewModel(with: subgroup.listOfSubgroups, and: muscleGroup.name)
        let subgroupViewController = MuscleSubgroupsViewController(viewModel: subGroupViewModel, trainingEntityTarget: target)
        return subgroupViewController
    }
    
    private func configureExerciseViewController(with muscleSubgroups: MuscleSubgroup.Subgroup, target: TrainingEntityTarget) -> ExerciseListViewController {
        let exerciseList = ExersiceModel(for: muscleSubgroups).listOfExercices
        let exerciseListModel: ExerciseListModel
        switch target {
        case .training:
            exerciseListModel = ExerciseListModel(trainingPatern: nil)
        case .trainingPatern(let patern):
            exerciseListModel = ExerciseListModel(trainingPatern: patern)
        case .showStatistics:
            exerciseListModel = ExerciseListModel(trainingPatern: nil)
        }
        let exerciseListViewController = ExerciseListViewController(trainingEntityTarget: target)
        let exerciseListViewModel = ExerciseListViewModel(with: exerciseList, and: muscleSubgroups.name)
        exerciseListViewController.viewModel = exerciseListViewModel
        exerciseListViewModel.model = exerciseListModel
        exerciseListViewModel.view = exerciseListViewController
        exerciseListModel.output = exerciseListViewModel
        return exerciseListViewController
    }
}
