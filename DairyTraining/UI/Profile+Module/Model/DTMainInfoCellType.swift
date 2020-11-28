import UIKit

enum ProfileInfoCellType: Int, CaseIterable {
    case totalTrain
    case activityLevel
    case gender
    case age
    case hight
    case weight
    
    var title: String {
        switch self {
        case .totalTrain:
            return LocalizedString.totalTrain
        case .activityLevel:
            return LocalizedString.activityLevel
        case .gender:
            return LocalizedString.gender
        case .age:
            return LocalizedString.age
        case .hight:
            return LocalizedString.height
        case .weight:
            return LocalizedString.weight
        }
    }
    
    var value: String {
        guard let userMainInfo = UserDataManager.shared.readUserMainInfo() else { return "-" }
        let trainingCount = TrainingDataManager.shared.getTraingList().count
        switch self {
        case .totalTrain:
            return String(trainingCount)
        case .activityLevel:
            return NSLocalizedString(userMainInfo.displayActivityLevel, comment: "")
        case .gender:
            return NSLocalizedString(userMainInfo.displayGender, comment: "")
        case .age:
            return userMainInfo.displayAge
        case .hight:
            return userMainInfo.displayHeight
        case .weight:
            return userMainInfo.displayWeight
        }
    }
    
    var description: String? {
        switch self {
        case .hight:
            return MeteringSetting.shared.heightDescription
        case .weight:
            return MeteringSetting.shared.weightDescription
        default:
            return nil
        }
    }
    
    var backgroubImage: UIImage? {
        switch self {
        case .totalTrain:
            return UIImage.totalTraininBackgroundImage
        case .activityLevel:
            return UIImage.activityLevelBackgroundImage
        case .gender:
            return UIImage.genderBackgroundImage
        case .age:
            return UIImage.ageBackgroundImage
        case .hight:
            return UIImage.heightBackgroundImage
        case .weight:
            return UIImage.weightBackgroundImage
        }
    }
}
