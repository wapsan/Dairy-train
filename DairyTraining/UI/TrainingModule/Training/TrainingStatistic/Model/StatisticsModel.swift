import Foundation

struct Statistics {
    
    //MARK: - Properties
    private lazy var weightDescription = UserDefaults.standard.weightMode.description//MeteringSetting.shared.weightDescription
    private var weightMetric: UserInfo.WeightMode {
        return UserDefaults.standard.weightMode
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
            return String(format: "%.0f", self._averageProjectileWeight) + UserDefaults.standard.weightMode.description//MeteringSetting.shared.weightDescription//self.weightDescription
        } else {
            return String(format: "%.1f", self._averageProjectileWeight) + UserDefaults.standard.weightMode.description//self.weightDescription
        }
    }
    
    var totalWorkoutWeight: String {
        if self._totalWorkoutWeight.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self._totalWorkoutWeight) + UserDefaults.standard.weightMode.description//self.weightDescription
        } else {
            return String(format: "%.1f", self._totalWorkoutWeight) + UserDefaults.standard.weightMode.description//self.weightDescription
        }
    }
    
    //MARK: - Private properties
    private var _numberOfTrainedSubgroups: Int
    private var _totalNumberOfReps: Int
    private var _totalNumberOfAproach: Int
    private var _totalWorkoutWeight: Float
    private var _averageProjectileWeight: Float
    
    //MARK: - Initialization
    init(for train: WorkoutMO) {
        self.trainingDate = train.formatedDate
        self._totalNumberOfAproach = {
            var aproaches = 0
            train.exercicesArray.forEach { (exercise) in
                exercise.aproachesArray.forEach { (aproach) in
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
                    let aproachWeightMode = aproach.weightMode
                    if aproachWeightMode == UserDefaults.standard.weightMode.rawValue {
                        totalWeight += (aproach.weightValue * Float(aproach.reps))
                    } else {
                        totalWeight += (aproach.weightValue * UserDefaults.standard.weightMode.multiplier * Float(aproach.reps))
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
                    let aproachWeightMode = aproach.weightMode
                    if aproachWeightMode == UserDefaults.standard.weightMode.rawValue {
                        averageProjectileWeight += aproach.weightValue
                        aproachesCountInTtrain += 1
                    } else {
                        averageProjectileWeight += (aproach.weightValue * UserDefaults.standard.weightMode.multiplier)
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
