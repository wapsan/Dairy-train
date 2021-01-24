import UIKit

final class WorkoutConfigurator {
    
    static func configure(for workout: TrainingManagedObject) -> WorkoutViewController {
        let trainingModel = WorkoutModel(with: workout)
        let trainingViewModel = WorkoutViewModel(model: trainingModel)
        let trainingViewController = WorkoutViewController(viewModel: trainingViewModel)
        let workoutRouter = WorkoutRouter(trainingViewController)
        trainingViewModel.view = trainingViewController
        trainingModel.output = trainingViewModel
        trainingViewModel.router = workoutRouter
        return trainingViewController
    }
 }
