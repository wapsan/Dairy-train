import UIKit

enum SideMenuItem: CaseIterable {
    case supplyRecomendation
    case statistics
    case premium
    case setting
    case termAndConditions
    case logOut
    
    var image: UIImage? {
        switch self {
        case .supplyRecomendation:
            return nil
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
        case .supplyRecomendation:
            return LocalizedString.recomendations
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
