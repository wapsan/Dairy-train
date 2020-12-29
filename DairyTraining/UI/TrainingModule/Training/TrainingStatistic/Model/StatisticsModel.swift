import Foundation

struct Statistics {
    
    //MARK: - Properties
    private lazy var weightDescription = MeteringSetting.shared.weightDescription
    private var weightMetric: MeteringSetting.WeightMode {
        return MeteringSetting.shared.weightMode
    }
    
    var trainingDate: String?
    var trainedSubGroupsList: [MuscleSubgroup.Subgroup]
    
    var numberOfTrainedSubgroups: String {
        return String(self._numberOfTrainedSubgroups)
    }
    
    var totalNumberOfReps: String {
        return String(self._totalNumberOfReps)
    }
    
    var totalNumberOfAproach: String {
        return String(self._totalNumberOfAproach)
    }
    
    var averageProjectileWeight: String {
        if self._averageProjectileWeight.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self._averageProjectileWeight) + MeteringSetting.shared.weightDescription//self.weightDescription
        } else {
            return String(format: "%.1f", self._averageProjectileWeight) + MeteringSetting.shared.weightDescription//self.weightDescription
        }
    }
    
    var totalWorkoutWeight: String {
        if self._totalWorkoutWeight.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self._totalWorkoutWeight) + MeteringSetting.shared.weightDescription//self.weightDescription
        } else {
            return String(format: "%.1f", self._totalWorkoutWeight) + MeteringSetting.shared.weightDescription//self.weightDescription
        }
    }
    
    //MARK: - Private properties
    private var _numberOfTrainedSubgroups: Int
    private var _totalNumberOfReps: Int
    private var _totalNumberOfAproach: Int
    private var _totalWorkoutWeight: Float
    private var _averageProjectileWeight: Float
    
    //MARK: - Initialization
    init(for train: TrainingManagedObject) {
        self.trainingDate = train.formatedDate
        self._totalNumberOfAproach = {
            var aproaches = 0
            train.exercicesArray.forEach { (exercise) in
                exercise.aproaches.forEach { (aproach) in
                    aproaches += 1
                }
            }
            return aproaches
        }()
        
        self._totalNumberOfReps = {
            var reps = 0
            train.exercicesArray.forEach { (exercise) in
                exercise.aproachesArray.forEach { (aproach) in
                    reps += Int(aproach.reps)
                }
            }
            return reps
        }()
        
        self._totalWorkoutWeight = {
            var totalWeight: Float = 0.0
            train.exercicesArray.forEach { (exercise) in
                exercise.aproachesArray.forEach { (aproach) in
                    guard let aproachWeightMode = aproach.weightEnumMode else { return }
                    if aproachWeightMode == MeteringSetting.shared.weightMode {
                        totalWeight += (aproach.weight * Float(aproach.reps))
                    } else {
                        totalWeight += (aproach.weight * MeteringSetting.shared.weightMultiplier * Float(aproach.reps))
                    }
                }
            }
            return totalWeight
        }()
        
        self._averageProjectileWeight = {
            var averageProjectileWeight: Float = 0.0
            var aproachesCountInTtrain: Float = 0.0
            train.exercicesArray.forEach { (exercise) in
                exercise.aproachesArray.forEach { (aproach) in
                    guard let aproachWeightMode = aproach.weightEnumMode else { return }
                    if aproachWeightMode == MeteringSetting.shared.weightMode {
                        averageProjectileWeight += aproach.weight
                        aproachesCountInTtrain += 1
                    } else {
                        averageProjectileWeight += (aproach.weight * MeteringSetting.shared.weightMultiplier)
                        aproachesCountInTtrain += 1
                    }
                    
                }
            }
            if aproachesCountInTtrain == 0 {
                return 0
            } else {
                return averageProjectileWeight / aproachesCountInTtrain
            }
        }()
        
        self.trainedSubGroupsList = train.muscleSubgroupInCurentTraint
        self._numberOfTrainedSubgroups = train.muscleSubgroupInCurentTraint.count
    }
}
