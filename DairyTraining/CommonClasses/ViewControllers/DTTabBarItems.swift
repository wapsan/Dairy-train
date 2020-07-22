import UIKit

enum DTTabBarItems {
    
    case activivties
    case profile
    case training
    
    private var tag: Int {
        switch self {
        case .activivties:
            return 0
        case .profile:
            return 2
        case .training:
            return 1
        }
    }
    
    private var image: UIImage? {
        switch self {
        case .activivties:
            return UIImage.tabBarActivities
        case .profile:
            return UIImage.tabBarProfile
        case .training:
            return UIImage.tabBarTrains
        }
    }
    
    var item: UITabBarItem {
        let item = UITabBarItem(title: nil,
                                image: self.image,
                                tag: self.tag)
        return item
    }
}
