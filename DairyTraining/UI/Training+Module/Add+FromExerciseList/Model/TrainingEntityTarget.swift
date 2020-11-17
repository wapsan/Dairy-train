import Foundation

enum TrainingEntityTarget {
    case training
    case trainingPatern(trainingPatern: TrainingPaternManagedObject? = nil)
    case showStatistics
}
