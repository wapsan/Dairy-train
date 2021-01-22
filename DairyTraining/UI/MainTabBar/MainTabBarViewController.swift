import UIKit

protocol MainTabBarViewProtocol: AnyObject {
    
}

final class MainTabBarViewController: UITabBarController {
        
    // MARK: - Module properties
    private let viewModel: MainTabBarViewModelProtocol
    
    //MARK: - Private properties
    private lazy var profileViewControllerIndex = 0
    
    // MARK: - GUI Properties
    private lazy var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: - Properties
    var isAddButtonHiden: Bool = false {
        didSet {
            addButton.isHidden = isAddButtonHiden
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAddTrainingButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.center.y = view.frame.maxY - tabBar.frame.height + (addButton.bounds.height / 4 )
    }
    
    // MARK: - Initialization
    init(viewModel: MainTabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupAddTrainingButton() {
        addButton.center.x = tabBar.center.x
        addButton.backgroundColor = DTColors.controllSelectedColor
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        self.view.addSubview(addButton)
        addButton.setImage(UIImage(named: "add"), for: UIControl.State.normal)
        addButton.addTarget(self, action: #selector(addButtonpressed), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    private func setup() {
        viewControllers = viewModel.viewControllers
        selectedIndex = viewModel.defaultControllerIndex
        
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
    
    // MARK: - Actions
    @objc private func addButtonpressed() {
        viewModel.centeredAddButtonPressed()
    }
}

extension MainTabBarViewController: MainTabBarViewProtocol {
    
}


