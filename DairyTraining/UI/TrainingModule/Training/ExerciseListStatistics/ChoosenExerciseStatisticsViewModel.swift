import Foundation

// MARK: - Protocol for ExerciseManagedObject to calculate statistics
protocol ExerciseStatistics {
    var avarageProjectileWeight: Double { get }
    var maxProjectileWeight: Double { get }
    var totalLiftingWeight: Double { get }
    var exerciseDate: Date { get }
    var avarageReps: Double { get }
}

extension ExerciseMO: ExerciseStatistics {
    
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
            sum += Double($0.weightValue)
        })
        return aproachesArray.count == 0 ? 0 : sum / Double(aproachesArray.count)
    }
    
    var maxProjectileWeight: Double {
        var maxWeight: Double
        maxWeight = (aproachesArray.map({ $0.weightValue.double }).max() ?? 0)
        return maxWeight
    }
    
    var totalLiftingWeight: Double {
        var sum: Double = 0
        aproachesArray.forEach({ sum += $0.weightValue.double * $0.reps.double})
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
    private var exercises: [ExerciseStatistics] = []
    private(set) var currentExerciseDate: Date?
    private let exercise: ExerciseMO
    private let persistenceService: PersistenceService
    
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
    init(exercise: ExerciseMO, persistenceService: PersistenceService = PersistenceService()) {
        self.persistenceService = persistenceService
        self.exercise = exercise
        self.exerciseTitle = exercise.name
        self.currentExerciseDate = exercise.date
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        exercises = persistenceService.exercise.getAllExerciseForStatistics(with: exercise.name)
    }
    
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
