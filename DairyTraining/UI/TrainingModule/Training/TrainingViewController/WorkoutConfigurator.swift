import UIKit

final class WorkoutConfigurator {
    
    static func configure(for workout: TrainingManagedObject) -> TrainingViewController {
        let trainingModel = TrainingModel(with: workout)
        let trainingViewModel = TrainingViewModel(model: trainingModel)
        let trainingViewController = TrainingViewController(viewModel: trainingViewModel)
        let workoutRouter = WorkoutRouter(trainingViewController)
        trainingViewModel.view = trainingViewController
        trainingModel.output = trainingViewModel
        trainingViewModel.router = workoutRouter
        return trainingViewController
    }
 }
