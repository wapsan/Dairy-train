import UIKit

extension UIViewController {
    
    func hideTabBar() {
        extendedLayoutIncludesOpaqueBars = true
        guard let tabBarController = tabBarController as? MainTabBarViewController else {
              return
        }
        tabBarController.isAddButtonHiden = true
        tabBarController.tabBar.isHidden = true
    }
    
    func showTabBar() {
        guard let tabBarController = tabBarController as? MainTabBarViewController else {
              return
        }
        tabBarController.isAddButtonHiden = false
        tabBarController.tabBar.isHidden = false
    }
    
}

extension UIViewController {
    
    func showDefaultAlert(title: String? = nil,
                          message: String? = nil,
                          preffedStyle: UIAlertController.Style = .alert,
                          okTitle: String? = nil,
                          cancelTitle: String?  = nil,
                          completion: (() -> Void)? = nil
    ) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preffedStyle)
        
        
        if let _ = okTitle {
            let okAction = UIAlertAction(title: okTitle, style: .default) { (_) in
                completion?()
            }
            alert.addAction(okAction)
        }
        
        if let _ = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
