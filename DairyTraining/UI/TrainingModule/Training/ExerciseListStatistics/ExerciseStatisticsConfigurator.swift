import Foundation

final class ExerciseStatisticsConfigurator {
    
    static func configure(for exercise: ExerciseMO) -> ChoosenExerciseStatisticsViewController {
        let exerciseStatisticsViewModel = ChoosenExerciseStatisticsViewModel(exercise: exercise)
        let exerciseStatisticsViewController = ChoosenExerciseStatisticsViewController(viewModel: exerciseStatisticsViewModel)
        return exerciseStatisticsViewController
    }
    
}
