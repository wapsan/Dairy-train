import Foundation

// MARK: - Protocol for ExerciseManagedObject to calculate statistics
protocol ExerciseStatistics {
    var avarageProjectileWeight: Double { get }
    var maxProjectileWeight: Double { get }
    var totalLiftingWeight: Double { get }
    var exerciseDate: Date { get }
    var avarageReps: Double { get }
}

extension ExerciseManagedObject: ExerciseStatistics {
    
    var avarageReps: Double {
        var avarageReps: Double = 0
        aproachesArray.forEach({
            avarageReps += Double($0.reps)
        })
        return avarageReps
    }
    
    var avarageProjectileWeight: Double {
        var sum: Double = 0
        aproachesArray.forEach({
            sum += Double($0.weight)
        })
        return aproachesArray.count == 0 ? 0 : sum / Double(aproachesArray.count)
    }
    
    var maxProjectileWeight: Double {
        var maxWeight: Double
        maxWeight = Double(aproachesArray.map({ $0.weight }).max() ?? 0)
        return maxWeight
    }
    
    var totalLiftingWeight: Double {
        var sum: Double = 0
        aproachesArray.forEach({ sum += Double($0.weight) * Double($0.reps)})
        return sum
    }
    
    var exerciseDate: Date {
        return date ?? Date()
    }
}

final class ChoosenExerciseStatisticsViewModel  {
    
    // MARK: - Properties
    private(set) var exerciseTitle: String
    private(set) var numberOfChartCell = 4
    private var exercises: [ExerciseStatistics]
    private(set) var currentExerciseDate: Date?
    
    private var maxWeightData: [ExerciseStatisticsData] {
        return exercises.sorted(by: { $0.exerciseDate < $1.exerciseDate })
            .map({ ExerciseStatisticsData(date: $0.exerciseDate, value: $0.maxProjectileWeight) })
    }
    private var avarageProjectileWeightData: [ExerciseStatisticsData] {
        return exercises.sorted(by: { $0.exerciseDate < $1.exerciseDate })
            .map({ ExerciseStatisticsData(date: $0.exerciseDate, value: $0.avarageProjectileWeight) })
    }
    private var sumProjectileWeightData: [ExerciseStatisticsData] {
        return exercises.sorted(by: { $0.exerciseDate < $1.exerciseDate })
            .map({ ExerciseStatisticsData(date: $0.exerciseDate, value: $0.totalLiftingWeight) })
    }
    private var avarageRepsData: [ExerciseStatisticsData] {
        return exercises.sorted(by: { $0.exerciseDate < $1.exerciseDate })
            .map({ ExerciseStatisticsData(date: $0.exerciseDate, value: $0.avarageReps) })
    }
    
    // MARK: - Initialization
    init(exersiceName: String, currentExerciseDate: Date?) {
        self.exercises = CoreDataManager.shared.fetchAllExerciseForStatistics(with: exersiceName) as [ExerciseStatistics]
        self.exerciseTitle = exersiceName
        self.currentExerciseDate = currentExerciseDate
    }
    
    // MARK: - Public methods
    func generateExerciseDataType(for index: Int) -> ExerciseSatisticType? {
        switch index {
        case 0:
            return ExerciseSatisticType.maxProjectileWeight(data: maxWeightData)
        case 1:
            return ExerciseSatisticType.avarageProjectileWeight(data: avarageProjectileWeightData)
        case 2:
            return ExerciseSatisticType.summProjectileWeight(data: sumProjectileWeightData)
        case 3:
            return ExerciseSatisticType.avarageReps(data: avarageRepsData)
        default:
            return nil
        }
    }
}
