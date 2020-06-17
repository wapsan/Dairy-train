import Foundation

class Statistics {
    
    //MARK: - Properties
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
        return String(format: "%.1f", self._averageProjectileWeight)
    }
    
    var totalWorkoutWeight: String {
        return String(self._totalWorkoutWeight)
    }
    
    //MARK: - Private properties
    private var _numberOfTrainedSubgroups: Int
    private var _totalNumberOfReps: Int
    private var _totalNumberOfAproach: Int
    private var _totalWorkoutWeight: Float
    
    private var _averageProjectileWeight: Float {
        if self._totalWorkoutWeight != 0 && self._totalNumberOfAproach != 0 {
            return self._totalWorkoutWeight / Float(self._totalNumberOfAproach)
        } else {
            return 0.0
        }
    }
    
    //MARK: - Initialization
    init(for train: Train) {
        self._numberOfTrainedSubgroups = train.subgroupInCurrentTrain.count
        self._totalNumberOfAproach = {
            var aproaches = 0
            train.exercises.forEach { (exercise) in
                exercise.aproaches.forEach { (aproach) in
                    aproaches += 1
                }
            }
            return aproaches
        }()
        self._totalNumberOfReps = {
            var reps = 0
            train.exercises.forEach { (exercise) in
                exercise.aproaches.forEach { (aproach) in
                    reps += aproach.reps
                }
            }
            return reps
        }()
        self._totalWorkoutWeight = {
            var totalWeight: Float = 0.0
            train.exercises.forEach { (exercise) in
                exercise.aproaches.forEach { (aproach) in
                    totalWeight += aproach.weight
                }
            }
            return totalWeight
        }()
        self.trainedSubGroupsList = train.subgroupInCurrentTrain
    }
}
