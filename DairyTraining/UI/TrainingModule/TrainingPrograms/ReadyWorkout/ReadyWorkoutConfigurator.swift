import Foundation

struct ReadyWorkoutConfigurator {
    
    func configureReadyWorkout(for workout: SpecialWorkout, and exercises: [Exercise]) -> ReadyWorkoutViewController {
        let readyWorkoutModel = ReadyWorkoutModel(workout: workout, exercises: exercises)
        let readyWorkoutViewModel = ReadyWorkoutViewModel(model: readyWorkoutModel)
        let readyWorkoutviewController = ReadyWorkoutViewController(viewModel: readyWorkoutViewModel)
        readyWorkoutViewModel.view = readyWorkoutviewController
        readyWorkoutModel.output = readyWorkoutViewModel
        return readyWorkoutviewController
    }
    
}
