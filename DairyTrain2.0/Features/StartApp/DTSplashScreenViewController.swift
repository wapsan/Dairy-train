import UIKit

class DTSplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        DTFirebaseFileManager.shared.updateLoggedInMainUserFromFirebase(completion: { 
            let profileViewController = MainTabBarViewController()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
