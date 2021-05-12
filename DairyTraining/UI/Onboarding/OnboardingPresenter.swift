import UIKit

protocol OnboardingPresenterProtocol: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var firstViewController: UIViewController { get }
    var viewControllersCount: Int { get }
    
    func skipButtonPressed()
}

final class OnboardingPresenter: NSObject {
    
    final class EmptyViewController: UIViewController { }
    
    private lazy var _pages = [view1, view2, view3, emptyViewController]
    let view1 = UIViewController()
    let view2 = UIViewController()
    let view3 = UIViewController()
    let emptyViewController = EmptyViewController()
    
    private var currentPageIndex = 0 {
        didSet {
            view?.updatePageControll(with: currentPageIndex)
        }
    }
    
    weak var view: OnboardingViewProtocol?
    var router: OnboardingRouter?
    
    override init() {
        
        view1.view.backgroundColor = .red
        view2.view.backgroundColor = .blue
        view3.view.backgroundColor = .green
        emptyViewController.view.backgroundColor = .cyan
        super.init()
    }
    
}

//MARK: - OnboardingViewModelProtocol
extension OnboardingPresenter: OnboardingPresenterProtocol {
    
    var viewControllersCount: Int {
        return _pages.count - 1
    }
    
    func skipButtonPressed() {
        router?.showAuthorizationScreen()
    }
    
    var firstViewController: UIViewController {
        return _pages.first ?? UIViewController()
    }
}

//MARK: - UIPageViewControllerDelegate/UIPageViewControllerDataSource
extension OnboardingPresenter {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextViewController = pendingViewControllers.first,
              nextViewController is EmptyViewController else { return }
        router?.showAuthorizationScreen()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = _pages.firstIndex(of: viewController) else { return nil }
        currentPageIndex = viewControllerIndex
        let nextIndex = viewControllerIndex + 1
        guard _pages.count != nextIndex, _pages.count > nextIndex else { return nil }
        
        return _pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = _pages.firstIndex(of: viewController) else { return nil }
        currentPageIndex = viewControllerIndex
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0, _pages.count > previousIndex else { return nil }
        
        return _pages[previousIndex]
    }
}
