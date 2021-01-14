import Foundation

protocol WorkoutStatisticsViewModelProtocol: TitledScreenProtocol {
    var statistics: Statistics { get }
    
    func backButtonPressed()
}

final class WorkoutStatisticsViewModel {
    
    // MARK: - Private properties
    let _statistics: Statistics
    
    // MARK: - Initialization
    init(statistics: Statistics) {
        self._statistics = statistics
    }
}

// MARK: - WorkoutStatisticsViewModelProtocol
extension WorkoutStatisticsViewModel: WorkoutStatisticsViewModelProtocol {
    
    func backButtonPressed() {
        MainCoordinator.shared.popViewController()
    }
    
    var statistics: Statistics {
        return _statistics
    }
    
    var title: String {
        return "Statistics"
    }
    
    var description: String {
        return "There is your statistics for wrokout"
    }
}