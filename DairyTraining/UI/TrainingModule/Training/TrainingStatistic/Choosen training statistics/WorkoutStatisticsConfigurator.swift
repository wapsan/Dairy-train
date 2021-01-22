import Foundation

final class WorkoutStatisticsConfigurator {
    
    static func configure(for workout: TrainingManagedObject) -> WorkoutStatisticsViewController {
        let statistics = Statistics(for: workout)
        let choosenStatisticsViewModel = WorkoutStatisticsViewModel(statistics: statistics)
        let choosenStatisticsViewController = WorkoutStatisticsViewController(viewModel: choosenStatisticsViewModel)
        return choosenStatisticsViewController
    }
}
