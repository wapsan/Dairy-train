import UIKit

extension SideMenuInteractor {
    
    // MARK: - Types
    enum MenuItem: CaseIterable {
        case premium
        case setting
        case termAndConditions
        case logOut
        
        var image: UIImage? {
            switch self {
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
}
