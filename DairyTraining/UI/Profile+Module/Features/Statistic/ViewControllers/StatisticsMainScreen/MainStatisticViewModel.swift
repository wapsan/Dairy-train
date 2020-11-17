import Foundation

final class MainStatisticViewModel {
    
    //MARK: - Types
    enum StatisticsType: CaseIterable {
        case byTraining
        case byExercises
        
        var name: String {
            switch self {
            case .byTraining:
                return "Statistics by training"
            case .byExercises:
                return "Statistics by exercises"
            }
        }
    }
    
    //MARK: - Properties
    var statisticTypes: [StatisticsType] {
        StatisticsType.allCases
    }
    
    //MARK: - Public methods
    func itemWasSelected(at index: Int) {
        switch StatisticsType.allCases[index] {
        case .byTraining:
            MainCoordinator.shared.coordinateChild(to: ProfileMenuCoordinator.Target.statisticsByTraining)
        case .byExercises:
            MainCoordinator.shared.coordinateChild(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .showStatistics))
        }
    }
}
