import UIKit

class MainTabBarVC: UITabBarController {
    
    //MARK: - Private properties
    private let profileIndex = 2
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setUpControllers()
        self.setTabBarItems()
        self.setSelectedTabBarItem()
        self.addObserverForAddingExerciceTotrain()
    }
    
    
    
    //MARK: - Private methods
    private func addObserverForAddingExerciceTotrain() {
        //Добавил обсервер для майн таб бар что бы когда добавил упражнения в тренировку и
       // не заходил в список тренирововк
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.exerciceDidAdd),
                                               name: .addExercicesToTrain,
                                               object: nil)
    }
    
    private func setSelectedTabBarItem() {
        self.selectedIndex = self.profileIndex
        
    }
    
    private func setUpControllers() {
      
        let profileVC = ProfileVC()
        let activitiesVC = ActivitiesVC()
        let trainsVC = TrainsVC()
        
        activitiesVC.tabBarItem = .init(title: nil, image: UIImage(named: "activities"), tag: 0)
        trainsVC.tabBarItem = .init(title: nil, image: UIImage(named: "trains"), tag: 1)
        profileVC.tabBarItem = .init(title: nil, image: UIImage(named: "profile"), tag: 2)
        
        self.viewControllers = [activitiesVC, trainsVC, profileVC].map({
            UINavigationController(rootViewController: $0)
        })
    }
    
    private func setTabBarItems() {
        UITabBar.appearance().tintColor = UIColor.white
        guard let itemViewControllers = self.viewControllers else { return }
        self.setDefaultTabBar()
        for itemViewController in itemViewControllers {
            itemViewController.tabBarItem.imageInsets = .init(top: 8,
                                                              left: 8,
                                                              bottom: 8,
                                                              right: 8)
        }
    }
    
    private func setDefaultTabBar() {
        //TODO: TabbarColor sets
        tabBar.isTranslucent = false
        tabBar.tintColor = .white //selected tab bat color
        tabBar.barTintColor = .viewFlipsideBckgoundColor//baclground tabbar color
        tabBar.unselectedItemTintColor = .red //unselected tab bar color
        self.setTabBarSeparationLine()
    }
    
    private func setTabBarSeparationLine() {
        if let items = self.tabBar.items {
            //Get the height of the tab bar
            let height = self.tabBar.bounds.height
            //Calculate the size of the items
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: tabBar.frame.width / numItems,
                height: tabBar.frame.height)
            
            for (index, _) in items.enumerated() {
                //We don't want a separator on the left of the first item.
                if index > 0 {
                    //Xposition of the item
                    let xPosition = itemSize.width * CGFloat(index)
                    /* Create UI view at the Xposition,
                     with a width of 0.5 and height equal
                     to the tab bar height, and give the
                     view a background color
                     */
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 0, width: 1, height: height))
                    separator.backgroundColor = UIColor.black
                    tabBar.insertSubview(separator, at: 1)
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc private func exerciceDidAdd(_ notification: NSNotification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let trains = userInfo["Exercices"] as? [Train] else { return }
        let trainVC = TrainsVC()
        trainVC.userTrainsList = trains
    }

}

//MARK: - Extension UITabBarControllerDelegate
extension MainTabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TestTabBarTransition(viewControllers: self.viewControllers)
    }
    
}

//MARK: - Transition viewcontrollers in TabBarVC
class TestTabBarTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.25

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
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

