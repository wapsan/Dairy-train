import Foundation
import SideMenu

final class SideMenuConfigurator {
    
    func configure(with delegate: SideMenuRouterDelegate) -> SideMenuNavigationController {
        let interactor = SideMenuInteractor()
        let presenter = SideMenuPresenter(interactor: interactor)
        let viewController = SideMenuViewController(presenter: presenter)
        
        let menu = SideMenuNavigationController(rootViewController: viewController)
        let router = SideMenuRouter(menu)
        
        router.delegate = delegate
        presenter.router = router
        interactor.output = presenter
        
        menu.leftSide = false
        menu.menuWidth = UIScreen.main.bounds.width * 0.7
        menu.statusBarEndAlpha = 0.0
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.presentingEndAlpha = 0.4
        menu.navigationBar.isHidden = true
        menu.modalPresentationStyle = .overCurrentContext
        menu.view.backgroundColor = .red
        
        return menu
    }
}
