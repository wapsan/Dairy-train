import Foundation


extension MonthlyStatisticsModel {
    
    //MARK: - Passive model
    struct Entity {
        let title: String
        let value: Float
        let description: String
    }
    
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
        
        var valueDescription: String {
            switch self {
            case .totalTraining, .totalSets, .totalReps:
                return ""
            case .avarageProjectileWeight, .totalWeightLifted:
                return UserDefaults.standard.weightMode.description
            case .totalTrainingTime:
                return "m."
            }
        }
        
        //MARK: - Private methods
        func calculateValue(monthlyWorkouts: [WorkoutMO]) -> Entity {
            switch self {
            case .totalTraining:
                return calculateWorkoutsCountInMounth(monthlyWorkouts)
                
            case .totalWeightLifted:
                return calculateTotalWeighLifted(monthlyWorkouts)
                
            case .avarageProjectileWeight:
                return calculateAvarageProjectioleWeight(monthlyWorkouts)
                
            case .totalTrainingTime:
                return calculateDuration(monthlyWorkouts)
                
            case .totalSets:
                return calculateTotalSets(monthlyWorkouts)
                
            case .totalReps:
                return calculateTotalReps(monthlyWorkouts)
                
            }
        }
        
        private func calculateWorkoutsCountInMounth(_ workouts: [WorkoutMO]) -> Entity {
            let entity = Entity(title: title, value: Float(workouts.count), description: valueDescription)
            return entity
        }
        
        private func calculateTotalWeighLifted(_ workouts: [WorkoutMO]) -> Entity {
            let weight = workouts.map({ $0.sumWeightOfTraining }).reduce(0, +)
            let entity = Entity(title: title, value: weight, description: valueDescription)
            return entity
        }
        
        private func calculateTotalSets(_ workouts: [WorkoutMO]) -> Entity {
            let sets = workouts.map({ $0.setsCount }).reduce(0, +)
            let entity = Entity(title: title, value: sets.float, description: valueDescription)
            return entity
        }
        
        private func calculateTotalReps(_ workouts: [WorkoutMO]) -> Entity {
            let reps = workouts.map({ $0.totalRepsCount }).reduce(0, +)
            let entity = Entity(title: title, value: Float(reps), description: valueDescription)
            return entity
        }
         
        private func calculateAvarageProjectioleWeight(_ workouts: [WorkoutMO]) -> Entity {
            let totalWeight = workouts.map({ $0.sumWeightOfTraining }).reduce(0, +)
            let totalReps = workouts.map({ $0.totalRepsCount }).reduce(0, +)
            let apw = totalWeight / Float(totalReps)
            let entity = Entity(title: title, value: apw, description: valueDescription)
            return entity
        }
        
        private func calculateDuration(_ workouts: [WorkoutMO]) -> Entity {
            let duration = workouts.map({ $0.duration }).reduce(0, +)
            let entity = Entity(title: title, value: Float(duration), description: valueDescription)
            return entity
        }
    }
}
