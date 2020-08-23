import UIKit

enum DTStatisticInfoCellType: Int, CaseIterable {
    
    case totalAproachNumber
    case totalRepsNumber
    case totalWorkoutWeight
    case avarageProjectileWeight
    case trainedSubgroup
    
    var title: String {
        switch self {
        case .totalAproachNumber:
            return LocalizedString.totalAproach
        case .totalRepsNumber:
            return LocalizedString.totalReps
        case .totalWorkoutWeight:
            return LocalizedString.totalTrainWeight
        case .avarageProjectileWeight:
            return LocalizedString.avarageProjectileWeigt
        case .trainedSubgroup:
            return LocalizedString.trainedMuscles
        }
    }
    
    func getValue(for statistics: Statistics) -> String? {
        switch self {
        case .totalAproachNumber:
            return statistics.totalNumberOfAproach
        case .totalRepsNumber:
            return statistics.totalNumberOfReps
        case .totalWorkoutWeight:
            return statistics.totalWorkoutWeight
        case .avarageProjectileWeight:
            return statistics.averageProjectileWeight
        case .trainedSubgroup:
            return nil
        }
    }
    
    var backgroundImage: UIImage? {
        switch self {
        case .totalAproachNumber:
            return UIImage.totalAproachBackgroundImage
        case .totalRepsNumber:
            return UIImage.totalRepsBackgroundImage
        case .totalWorkoutWeight:
            return UIImage.totalTrainingWeightbackgroundImage
        case .avarageProjectileWeight:
            return UIImage.avareProjectileWeightBackgroundImage
        case .trainedSubgroup:
            return nil
        }
    }
}
