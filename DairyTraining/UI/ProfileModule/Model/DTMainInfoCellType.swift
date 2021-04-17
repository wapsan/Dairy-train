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
    
    var description: String? {
        switch self {
        case .hight:
            return UserDefaults.standard.heightMode.description
        case .weight:
            return UserDefaults.standard.weightMode.description
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
