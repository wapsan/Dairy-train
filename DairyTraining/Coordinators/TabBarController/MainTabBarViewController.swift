import UIKit

final class MainTabBarViewController: UITabBarController {
        
    //MARK: - Private properties
    private lazy var profileViewControllerIndex = 2
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: - Private methods
    private func setup() {
        delegate = self
        viewControllers = [MainCoordinator.shared.nutritionBlockNavigationController,
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
    }
}

//MARK: - UITabBarControllerDelegate
extension MainTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransitionAnimation(viewControllers: self.viewControllers)
    }
}

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
