import Foundation

struct ReadyWorkoutConfigurator {
    
    func configureReadyWorkout(for workout: SpecialWorkout) -> ReadyWorkoutViewController {
        let readyWorkoutModel = ReadyWorkoutModel(workout: workout)
        let readyWorkoutViewModel = ReadyWorkoutViewModel(model: readyWorkoutModel)
        let readyWorkoutviewController = ReadyWorkoutViewController(viewModel: readyWorkoutViewModel)
        readyWorkoutViewModel.view = readyWorkoutviewController
        readyWorkoutModel.output = readyWorkoutViewModel
        return readyWorkoutviewController
    }
    
}
