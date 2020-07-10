import UIKit

class MainTabBarItemVC: UIViewController {
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCurrentTabBarController()
    }
    
    //MARK: - Private methods
    private func setUpCurrentTabBarController() {
        self.view.backgroundColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .viewFlipsideBckgoundColor
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationController?.navigationBar.barStyle = .black
        
        switch self.tabBarItem.tag {
        case 0:
            self.navigationItem.title = LocalizedString.activities
        case 1:
            self.navigationItem.title = LocalizedString.training
        case 2:
            self.navigationItem.title = LocalizedString.profile
        default:
            break
        }
    }
}
