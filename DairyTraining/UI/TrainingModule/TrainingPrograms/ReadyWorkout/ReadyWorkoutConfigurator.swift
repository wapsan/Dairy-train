import Foundation

final class ReadyWorkoutConfigurator {
    
    static func configure(for workout: SpecialWorkout) -> ReadyWorkoutViewController {
        let readyWorkoutModel = ReadyWorkoutModel(workout: workout)
        let readyWorkoutViewModel = ReadyWorkoutViewModel(model: readyWorkoutModel)
        let readyWorkoutviewController = ReadyWorkoutViewController(viewModel: readyWorkoutViewModel)
        let router = ReadyWotkoutRouter(readyWorkoutviewController)
        readyWorkoutViewModel.router = router
        readyWorkoutViewModel.view = readyWorkoutviewController
        readyWorkoutModel.output = readyWorkoutViewModel
        return readyWorkoutviewController
    }
    
}
