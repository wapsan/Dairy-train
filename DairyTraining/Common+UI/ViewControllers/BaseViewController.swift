import UIKit

class BaseViewController: UIViewController {
    
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

        self.view.backgroundColor = DTColors.backgroundColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
    
        self.navigationController?.navigationBar.layer.shadowColor = DTColors.controllBorderColor.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false

        self.navigationController?.navigationBar.barTintColor = DTColors.navigationBarColor
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationController?.navigationBar.barStyle = .black
    }
}
