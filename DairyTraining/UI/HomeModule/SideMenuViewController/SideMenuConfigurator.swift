import Foundation
import SideMenu

final class SideMenuConfigurator {
    
    func configure(with delegate: SideMenuRouterDelegate ) -> SideMenuNavigationController {
        let sideMenuModel = SideMenuModel()
        let sideMenuViewModel = SideMenuViewModel(model: sideMenuModel)
        let sideMenu = SideMenuViewController(viewModel: sideMenuViewModel)
        let menu = SideMenuNavigationController(rootViewController: sideMenu)
        let sideMenuRouter = SideMenuRouter(menu)
        sideMenuRouter.delegate = delegate
        sideMenuViewModel.router = sideMenuRouter
        sideMenuModel.output = sideMenuViewModel
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
