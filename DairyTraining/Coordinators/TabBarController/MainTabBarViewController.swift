import UIKit

final class MainTabBarViewController: UITabBarController {
        
    //MARK: - Private properties
    private lazy var profileViewControllerIndex = 0
    
    // MARK: - GUI Properties
    private lazy var menuButton = UIButton(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tabBar.bounds.height / 1.8 ,
                                                         height: tabBar.bounds.height / 1.8))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupMiddleButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuButton.center.y = view.frame.maxY - tabBar.frame.height + (menuButton.bounds.height / 2 ) + 8
    }
    
    //MARK: - Private methods

    
    
    func setupMiddleButton() {
        menuButton.center.x = tabBar.center.x
        menuButton.backgroundColor = DTColors.controllSelectedColor
        menuButton.layer.cornerRadius = 5
        self.view.addSubview(menuButton)
        menuButton.setImage(UIImage(named: "add"), for: UIControl.State.normal)
        menuButton.addTarget(self, action: #selector(addButtonpressed), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    @objc private func addButtonpressed() {
        print("Add button ressed")
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
        tabBar.items?.enumerated().forEach({
            if $0 == 2 { $1.isEnabled = false }
        })
    }
}

//MARK: - UITabBarControllerDelegate
//extension MainTabBarViewController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return TabBarTransitionAnimation(viewControllers: self.viewControllers)
//    }
//}

//MARK: - Transition viewcontrollers in TabBarViewController with animation
class TabBarTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.2
    
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
            UIView.animate(withDuration: self.transitionDuration, delay: 0, options: .curveEaseInOut) {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            } completion: { (success) in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
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
