import Foundation
//import Charts

protocol ExerciseStatistics {
    var avarageProjectileWeight: Double { get }
    var maxProjectileWeighkt: Double { get }
    var summProjectailWeight: Double { get }
    var exerciseDate: Date { get }
}

extension ExerciseManagedObject: ExerciseStatistics {
    
    var avarageProjectileWeight: Double {
        var sum: Double = 0
        aproachesArray.forEach({
            sum += Double($0.weight)
        })
        return aproachesArray.count == 0 ? 0 : sum / Double(aproachesArray.count)
    }
    
    var maxProjectileWeighkt: Double {
        var maxWeight: Double
        aproachesArray.sort(by: { $0.weight > $1.weight })
        maxWeight = Double(aproachesArray.first?.weight ?? 0)
        return maxWeight
    }
    
    var summProjectailWeight: Double {
        var sum: Double = 0
        aproachesArray.forEach({
            sum += Double($0.weight) * Double($0.reps)
        })
        return sum
    }
    
    var exerciseDate: Date {
        return date ?? Date()
    }
    
    
}

final class ChoosenExerciseStatisticsViewModel  {
    
    
    var exercises: [ExerciseStatistics]
    //var chartData: LineChartData?
    var testArray = [20, 23, 12, 34, 58, 56, 74, 50, 60, 44, 56, 43, 32]
    init(exersiceName: String) {
        self.exercises = CoreDataManager.shared.fetchAllExerciseForStatistics(with: exersiceName) as? [ExerciseStatistics] ?? []
        exercises.forEach({ print("Max projectile weight:\($0.maxProjectileWeighkt)")})
        exercises.forEach({ print("Avarage projectile weight:\($0.avarageProjectileWeight)") })
        exercises.forEach({ print("Sum projectile weight:\($0.summProjectailWeight)") })
        //exercises.forEach({ print("Dates:\($0.dates)") })
        //self.chartData = generateChartData()
        //generateChartData()
    }
    
    func generateExerciseDataType(for index: Int) -> ExerciseSatisticType? {
        switch index {
        case 0:
            return ExerciseSatisticType.maxProjectileWeight(data: generateMaxWeightDataType())
        case 1:
            return ExerciseSatisticType.avarageProjectileWeight(data: generateAvarageProjectileWeight())
        case 2:
            return ExerciseSatisticType.summProjectileWeight(data: generateSumProjectileWeight())
        default:
            return nil
        }
    }
    
    func generateMaxWeightDataType() -> [ExerciseStatisticsData] {
        var data: [ExerciseStatisticsData] = []
        exercises.forEach({
            data.append(ExerciseStatisticsData(date: $0.exerciseDate,
                                               weight: $0.maxProjectileWeighkt,
                                               reps: nil))
        })
        return data
    }
    
    func generateAvarageProjectileWeight() -> [ExerciseStatisticsData] {
        var data: [ExerciseStatisticsData] = []
        exercises.forEach({
            data.append(ExerciseStatisticsData(date: $0.exerciseDate,
                                               weight: $0.avarageProjectileWeight,
                                               reps: nil))
        })
        return data
    }
    
    func generateSumProjectileWeight() -> [ExerciseStatisticsData] {
        var data: [ExerciseStatisticsData] = []
        exercises.forEach({
            data.append(ExerciseStatisticsData(date: $0.exerciseDate,
                                               weight: $0.summProjectailWeight,
                                               reps: nil))
        })
        return data
    }
    
//    func generateChartData() {
//        var a: [ChartDataEntry] = []
//
//        for (index, value) in testArray.enumerated() {
//            let dataEntry = ChartDataEntry(x: Double(index + 1), y: Double(value))
//            a.append(dataEntry)
//        }
//        let b = LineChartDataSet(entries: a, label: "Weight, Kg")
//       // b.entries.forEach({ entry })
//
//        b.formSize = 20
//        b.mode = .cubicBezier
//        b.fillColor = .cyan
//        b.lineWidth = 2
//        b.drawFilledEnabled = true
//        b.circleRadius = 5
//        b.circleHoleRadius = 2
//        b.fillColor = DTColors.controllSelectedColor
//        b.circleHoleColor = DTColors.backgroundColor
//        b.circleColors = .init(repeating: DTColors.controllSelectedColor, count: testArray.count)
//        b.colors = .init(repeating: DTColors.controllSelectedColor, count: 1)
//        b.valueColors = .init(repeating: .white, count: testArray.count)
//        b.valueFont = .systemFont(ofSize: 15)
//        b.highlightEnabled = false
//        let z = LineChartData(dataSet: b)
//        self.chartData = z
//    }
    
    
    
}
