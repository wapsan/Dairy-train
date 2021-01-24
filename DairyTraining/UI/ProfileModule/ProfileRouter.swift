import UIKit

protocol ProfileRouterProtocol: AnyObject {

}

final class ProfileRouter: Router {
    
    
    private let rootViewController: ProfileViewController?
    
    init(_ viewController: UIViewController) {
        self.rootViewController = viewController as? ProfileViewController
    }
        
}

//MARK: - ProfileRouterOutputt
extension ProfileRouter: ProfileRouterProtocol {
    
}
