import UIKit

class MainTabBarViewController: UITabBarController {
        
    //MARK: - Private properties
    private lazy var profileViewControllerIndex = 2
    
    //MARK: - GUI Properties
    private lazy var leftSwipe: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self,
                                             action: #selector(self.swipeControllers(_:)))
        swipe.direction = .left
        return swipe
    }()
    
    private lazy var rightSwipe: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self,
                                             action: #selector(self.swipeControllers(_:)))
        swipe.direction = .right
        return swipe
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setUpTabBarViewControllers()
        self.setUpTabBarItems()
        self.setUpSelectedTabBarItem()
      //  self.addObserverForAddingExerciceToTrain()
        self.setUpSwipes()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //MARK: - Private methods
    private func setUpSwipes() {
        self.view.addGestureRecognizer(self.leftSwipe)
        self.view.addGestureRecognizer(self.rightSwipe)
    }
    
//    private func addObserverForAddingExerciceToTrain() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.exerciceDidAdd),
//                                               name: .trainingListWasChanged,
//                                               object: nil)
//    }
    
    private func setUpSelectedTabBarItem() {
        self.selectedIndex = self.profileViewControllerIndex
    }
    
//    func configureProfileVC() -> ProfileViewController {
//        let profileVC = ProfileViewController()
//        let profileViewModel = ProfileViewModel()
//        let profileModel = ProfileModel()
//        let profileRouter = ProfileRouter(profileVC)
//      
//        profileVC.viewModel = profileViewModel
//        profileVC.router = profileRouter
//        profileViewModel.model = profileModel
//        profileViewModel.view = profileVC
//        profileModel.output = profileViewModel
//        profileVC.tabBarItem = DTTabBarItems.profile.item
//        return profileVC
//    }
    
    func configureMuscleVC() -> MuscleGroupsViewController {
        let muscleGroupsVC = MuscleGroupsViewController()
        let muscleGroupsViewMode = MuscleGroupsViewModel()
        let muscleGroupsRouter = MuscleGroupsRouter(muscleGroupsVC)
        muscleGroupsVC.viewModel = muscleGroupsViewMode
        muscleGroupsVC.router = muscleGroupsRouter
        muscleGroupsViewMode.viewPresenter = muscleGroupsVC
        return muscleGroupsVC
        
    }
    
    func configureTestPVC() -> ProfileViewController {
        let testPVC = ProfileViewController()
        let testPVM = ProfileViewModel()
        let testPM = ProfileModel()
        let testPR = ProfileRouter(testPVC)
        testPVC.router = testPR
        testPVC.viewModel = testPVM
        testPVM.view = testPVC
        testPVM.model = testPM
        testPM.output = testPVM
        return testPVC
    }
    
    func configureTrainigListViewController() -> TrainingListViewController {
        let trainingListVC = TrainingListViewController()
        let trainingListVM = TrainingListViewModel()
        let trainingListM = TrainingListModel()
        let trainingListR = TrainingListRouter(trainingListVC)
        trainingListVC.viewModel = trainingListVM
        trainingListVM.router = trainingListR
        trainingListVM.view = trainingListVC
        trainingListVM.model = trainingListM
        trainingListM.output = trainingListVM
        return trainingListVC
    }
    
    private func setUpTabBarViewControllers() {
        let profileViewController = self.configureTestPVC()//TestPVC()//self.configureProfileVC() //ProfileViewController()
        let activitiesViewController = MainNutritionVIewController()//self.configureMuscleVC()//MuscleGroupsViewController()
        let trainingListViewController = self.configureTrainigListViewController()//TrainingListViewController()
        
        profileViewController.tabBarItem = DTTabBarItems.profile.item
        activitiesViewController.tabBarItem = DTTabBarItems.nutrition.item
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
        self.tabBar.barTintColor = DTColors.navigationBarColor
        self.tabBar.unselectedItemTintColor = DTColors.controllSelectedColor
        //
        self.tabBar.layer.shadowColor = DTColors.controllBorderColor.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        //self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.tabBar.layer.shadowOpacity = 1.0
        self.tabBar.layer.masksToBounds = false
        
    
        
      //  self.setTabBarSeparationLine()
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
    @objc private func swipeControllers(_ swipe: UISwipeGestureRecognizer) {
        guard let controllersCount = self.viewControllers?.count else { return }
        switch swipe.direction {
        case .right:
            if self.selectedIndex >= 0 && self.selectedIndex < controllersCount {
                self.selectedIndex = self.selectedIndex - 1
            }
        case .left:
            if self.selectedIndex >= 0 && self.selectedIndex < controllersCount {
                self.selectedIndex = self.selectedIndex + 1
            }
        default:
            break
        }
    }
    
//    @objc private func exerciceDidAdd(_ notification: NSNotification) {
//        guard let userInfo = (notification as NSNotification).userInfo else { return }
//        guard let trains = userInfo["Trains"] as? [TrainingManagedObject] else { return }
//        let trainigsViewController = TrainingListViewController()
//        trainigsViewController.setFor(trains)
//    }
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
