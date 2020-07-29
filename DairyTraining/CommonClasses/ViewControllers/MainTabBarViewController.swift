import UIKit

class MainTabBarViewController: UITabBarController {
        
    //MARK: - Private properties
    private lazy var profileViewControllerIndex = 2
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setUpTabBarViewControllers()
        self.setUpTabBarItems()
        self.setUpSelectedTabBarItem()
        self.addObserverForAddingExerciceToTrain()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //MARK: - Private methods
    private func addObserverForAddingExerciceToTrain() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.exerciceDidAdd),
                                               name: .trainingListWasChanged,
                                               object: nil)
    }
    
    private func setUpSelectedTabBarItem() {
        self.selectedIndex = self.profileViewControllerIndex
    }
    
    func configureProfileVC() -> ProfileViewController {
        let profileVC = ProfileViewController()
        let profileViewModel = ProfileViewModel()
        let profileModel = ProfileModel()
      
        profileVC.viewModel = profileViewModel
        profileViewModel.model = profileModel
        profileViewModel.viewPresenter = profileVC
        profileModel.delegate = profileViewModel
        profileVC.tabBarItem = DTTabBarItems.profile.item
        return profileVC
    }
    
    func configureMuscleVC() -> MuscleGroupsViewController {
        let muscleGroupsVC = MuscleGroupsViewController()
        let muscleGroupsViewMode = MuscleGroupsViewModel()
        muscleGroupsVC.viewModel = muscleGroupsViewMode
        muscleGroupsViewMode.viewPresenter = muscleGroupsVC
        return muscleGroupsVC
        
    }
    
    private func setUpTabBarViewControllers() {
        let profileViewController = self.configureProfileVC() //ProfileViewController()
        let activitiesViewController = self.configureMuscleVC()//MuscleGroupsViewController()
        let trainingListViewController = TrainingListViewController()
        
        profileViewController.tabBarItem = DTTabBarItems.profile.item
        activitiesViewController.tabBarItem = DTTabBarItems.activivties.item
        trainingListViewController.tabBarItem = DTTabBarItems.training.item
        
        self.viewControllers = [activitiesViewController,
                                trainingListViewController,
                                profileViewController]
            .map({ UINavigationController(rootViewController: $0) })
    }
    
    private func setUpTabBarItems() {
        self.setDefaultTabBar()
        guard let itemViewControllers = self.viewControllers else { return }
        for itemViewController in itemViewControllers {
            itemViewController.tabBarItem.imageInsets = .init(top: 8,
                                                              left: 8,
                                                              bottom: 8,
                                                              right: 8)
        }
    }
    
    private func setDefaultTabBar() {
        UITabBar.appearance().tintColor = UIColor.white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .viewFlipsideBckgoundColor
        self.tabBar.unselectedItemTintColor = .red
        self.setTabBarSeparationLine()
    }
    
    private func setTabBarSeparationLine() {
        if let items = self.tabBar.items {
            
            let height = self.tabBar.bounds.height
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: tabBar.frame.width / numItems,
                height: tabBar.frame.height)
            
            for (index, _) in items.enumerated() {
                if index > 0 {
                    let xPosition = itemSize.width * CGFloat(index)
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 0, width: 1, height: height))
                    separator.backgroundColor = UIColor.white
                    tabBar.insertSubview(separator, at: 1)
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc private func exerciceDidAdd(_ notification: NSNotification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let trains = userInfo["Trains"] as? [TrainingManagedObject] else { return }
        let trainigsViewController = TrainingListViewController()
        trainigsViewController.setFor(trains)
    }
}

//MARK: - UITabBarControllerDelegate
extension MainTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransitionAnimation(viewControllers: self.viewControllers)
    }
}

//MARK: - Transition viewcontrollers in TabBarViewController
class TabBarTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.25
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
