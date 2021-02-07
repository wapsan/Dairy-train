import Foundation


extension MonthlyStatisticsModel {
    
    //MARK: - Passive model
    enum StatisticsItem: CaseIterable {
        case totalTraining
        case totalWeightLifted
        case avarageProjectileWeight
        case totalTrainingTime
        case totalSets
        case totalReps
                
        var title: String {
            switch self {
            case .totalTraining:
                return "Training"
            case .totalWeightLifted:
                return "Weight lifted"
            case .avarageProjectileWeight:
                return "Apw"
            case .totalTrainingTime:
                return "Training time"
            case .totalSets:
                return "Sets"
            case .totalReps:
                return "Reps"
            }
        }
        
        var value: String {
            switch self {
            case .totalTraining:
                return calculateWorkoutsCountInMounth()
                
            case .totalWeightLifted:
                return calculateTotalWeighLifted()
                
            case .avarageProjectileWeight:
                return calculateAvarageProjectioleWeight()
                
            case .totalTrainingTime:
                return calculateDuration()
                
            case .totalSets:
                return calculateTotalSets()
                
            case .totalReps:
                return  calculateTotalReps()
            }
        }
        
        var valueDescription: String {
            switch self {
            case .totalTraining, .totalSets, .totalReps:
                return ""
            case .avarageProjectileWeight, .totalWeightLifted:
                return MeteringSetting.shared.weightDescription
            case .totalTrainingTime:
                return "m."
            }
        }
        
        //MARK: - Private methods
        private func calculateWorkoutsCountInMounth() -> String {
            let workoutsCount = TrainingDataManager.shared.mounthWorkouts().count
            return String(workoutsCount)
        }
        
        private func calculateTotalWeighLifted() -> String {
            let monthlyWorkout = TrainingDataManager.shared.mounthWorkouts().map({ $0.sumWeightOfTraining })
            let weight = monthlyWorkout.reduce(0, +)
            let format = weight.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f"
            return String(format: format, weight)
        }
        
        private func calculateTotalSets() -> String {
            let setsArray = TrainingDataManager.shared.mounthWorkouts().map({ $0.setsCount })
            let sets = setsArray.reduce(0, +)
            return String(sets)
        }
        
        private func calculateTotalReps() -> String {
            let repsArray = TrainingDataManager.shared.mounthWorkouts().map({ $0.totalRepsCount })
            let reps = repsArray.reduce(0, +)
            return String(reps)
        }
        
        private func calculateAvarageProjectioleWeight() -> String {
            let totalWeight = TrainingDataManager.shared.mounthWorkouts()
                .map({ $0.sumWeightOfTraining })
                .reduce(0, +)
            
            let totalReps = TrainingDataManager.shared.mounthWorkouts()
                .map({ $0.totalRepsCount })
                .reduce(0, +)
            
            let apw = totalWeight / totalReps
            let format = apw.truncatingRemainder(dividingBy: 0) == 1 ? "%.0f" : "%.1f"
            return String(format: format, apw)
        }
        
        private func calculateDuration() -> String {
            let duration = TrainingDataManager.shared.mounthWorkouts().map({ $0.duration }).reduce(0, +)
            return String(duration)
        }
        
    }
}
