import UIKit

enum SideMenuItem: CaseIterable {
    case statistics
    case premium
    case setting
    case termAndConditions
    case logOut
    
    var image: UIImage? {
        switch self {
        case .statistics:
            return nil
        case .setting:
            return nil
        case .logOut:
            return nil
        case .premium:
            return nil
        case .termAndConditions:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .statistics:
            return LocalizedString.statistics
        case .setting:
            return LocalizedString.setting
        case .logOut:
            return LocalizedString.signOut
        case .premium:
            return "Premium"
        case .termAndConditions:
            return "Terms & conditions"
        }
    }
}
