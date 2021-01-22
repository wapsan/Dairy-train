import UIKit

final class SelectExerciseConfigurator {
    
    func configure(for muscleGroup: MuscleGroup.Group, trainingEntityTarget: TrainingEntityTarget) -> SelectExerciseViewController {
        let exerciseNewModel = SelectExerciseModel(muscularGroup: muscleGroup, trainingEntityTarget: trainingEntityTarget)
        let exerciseNewViewModel = SelectExerciseViewModel(model: exerciseNewModel)
        let exerciseNewViewController = SelectExerciseViewController(viewModel: exerciseNewViewModel)
        let addExerciseRouter = SelectExerciseRouter(exerciseNewViewController)
        exerciseNewModel.viewModel = exerciseNewViewModel
        exerciseNewViewModel.view = exerciseNewViewController
        exerciseNewViewModel.router = addExerciseRouter
        return exerciseNewViewController
    }
}
