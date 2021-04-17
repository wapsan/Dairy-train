import UIKit

final class WorkoutConfigurator {
    
    static func configure(for workout: WorkoutMO) -> WorkoutViewController {
        let trainingModel = WorkoutIneractor(with: workout)
        let trainingViewModel = WorkoutPresenter(model: trainingModel)
        let trainingViewController = WorkoutViewController(viewModel: trainingViewModel)
        let workoutRouter = WorkoutRouter(trainingViewController)
        
        trainingViewModel.view = trainingViewController
        trainingModel.output = trainingViewModel
        trainingViewModel.router = workoutRouter
        
        return trainingViewController
    }
 }
