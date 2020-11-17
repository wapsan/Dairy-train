import UIKit

enum SideMenuItem: CaseIterable {
    case supplyRecomendation
    case statistics
    case setting
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
        }
    }
}
