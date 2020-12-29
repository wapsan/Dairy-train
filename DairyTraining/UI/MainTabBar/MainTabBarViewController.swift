import UIKit

final class MainTabBarViewController: UITabBarController {
        
    //MARK: - Private properties
    private lazy var profileViewControllerIndex = 0
    
    // MARK: - GUI Properties
    private lazy var addButton = UIButton(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: 50,
                                                         height: 50))
    
    var isAddButtonHiden: Bool = false {
        didSet {
            addButton.isHidden = isAddButtonHiden
        }
    }
    private lazy var a = CreateTrainingPopUp.view()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupMiddleButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.center.y = view.frame.maxY - tabBar.frame.height + (addButton.bounds.height / 4 )// + 8
    }
    
    //MARK: - Private methods
    private func setupMiddleButton() {
        addButton.center.x = tabBar.center.x
        addButton.backgroundColor = DTColors.controllSelectedColor
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        self.view.addSubview(addButton)
        addButton.setImage(UIImage(named: "add"), for: UIControl.State.normal)
        addButton.addTarget(self, action: #selector(addButtonpressed), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    @objc private func addButtonpressed() {
        a?.preseent()
       // print("Add button ressed")
    }
    
    
    private func setup() {
        viewControllers = [MainCoordinator.shared.homeNavigationViewController,
                           MainCoordinator.shared.nutritionBlockNavigationController,
                           TabBarItemController.addButton.navigationController,
                           MainCoordinator.shared.trainingBlockNavigationController,
                           MainCoordinator.shared.profileNavigationController]
        selectedIndex = profileViewControllerIndex
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.barTintColor = DTColors.navigationBarColor
        tabBar.unselectedItemTintColor = DTColors.controllSelectedColor
        tabBar.layer.shadowColor = DTColors.controllBorderColor.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.masksToBounds = false
        tabBar.items?.enumerated().forEach({ if $0 == 2 { $1.isEnabled = false } })
    }
}
