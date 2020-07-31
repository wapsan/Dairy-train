import UIKit

protocol ProfileViewModelInput: AnyObject {
    func signOut()
    func showMenu()
    func configureInfoViews(_ infoViews: [DTInfoView])    
}

class ProfileViewModel {
    //MARK: - Properties
    private var _isAllInfoViewSet: Bool = false
    
    var model: ProfileModelIteracting!
    var view: ProfileViewPresenter!
}

//MARK: - ProfileViewModelInput
extension ProfileViewModel: ProfileViewModelInput {

    func configureInfoViews(_ infoViews: [DTInfoView]) {
        for view in infoViews {
            if view.isValueSeted {
                self._isAllInfoViewSet = true
            } else {
                self._isAllInfoViewSet = false
                break
            }
        }
    }
    
    func showMenu() {
        self.view.showMenu()
    }
    
    func signOut() {
        self.model.signOut()
    }
}

//MARK: - ProfileModelOutput
extension ProfileViewModel: ProfileModelOutput {
    
    func succesSignedOut() {
        self.view.presentLoginViewController()
    }
    
    func errorSignedOut(error: Error) {
        self.view.showErrorSignOutAlert(with: error)
    }
}

//MARK: - MenuStackViewControllerDelegate
extension ProfileViewModel: MenuControllerDelegate {
    
    func menuFlowSelected(_ pushedViewController: UIViewController) {
        guard pushedViewController is RecomendationsViewController else {
            self.view.pushViewControllerFromMenu(pushedViewController)
            return
        }
        if self._isAllInfoViewSet {
            self.view.pushViewControllerFromMenu(pushedViewController)
        } else {
            self.view.showRecomendationAlert()
        }
    }
    
    func menuSignOutPressed() {
        self.view.showSignOutAlert()
    }
}
