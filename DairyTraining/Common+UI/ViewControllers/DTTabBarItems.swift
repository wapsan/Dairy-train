import UIKit

enum DTTabBarItems {
    
    case nutrition
    case profile
    case training
    
    private var tag: Int {
        switch self {
        case .nutrition:
            return 0
        case .profile:
            return 2
        case .training:
            return 1
        }
    }
    
    private var image: UIImage? {
        switch self {
        case .nutrition:
            return UIImage(named: "nutrition")
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
