import UIKit

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
    


    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.5) {
      if self.tabBarController?.tabBar.isHidden != hidden{
          if animated {
              //Show the tabbar before the animation in case it has to appear
              if (self.tabBarController?.tabBar.isHidden) ?? false {
                  self.tabBarController?.tabBar.isHidden = hidden
              }
              if let frame = self.tabBarController?.tabBar.frame {
                  let factor: CGFloat = hidden ? 1 : -1
                  let y = frame.origin.y + (frame.size.height * factor)
                  UIView.animate(withDuration: duration, animations: {
                      self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                  }) { (bool) in
                      //hide the tabbar after the animation in case ti has to be hidden
                    if (!(self.tabBarController?.tabBar.isHidden ?? true)) {
                          self.tabBarController?.tabBar.isHidden = hidden
                      }
                  }
              }
          }
      }

    }
}

extension UITabBar {
    
    func hide(_ hidden: Bool, animated: Bool, duration: TimeInterval) {
        if isHidden != hidden {
            if animated {
                if isHidden {
                    isHidden = hidden
                }
                
                let factor: CGFloat = hidden ? 1 : -1
                let y  = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
                }) { (bool) in
                    //hide the tabbar after the animation in case ti has to be hidden
                    if !self.isHidden {
                        self.isHidden = hidden
                    }
                }
            }
        }
    }
    
}
