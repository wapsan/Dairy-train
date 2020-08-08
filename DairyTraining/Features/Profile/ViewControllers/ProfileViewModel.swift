//import UIKit
//
//protocol ProfileViewModelInput: AnyObject {
//    func signOut()
//    func showMenu()
//    var isMainInfoSet: Bool { get }
//}
//
//class ProfileViewModel {
//    
//    //MARK: - Properties
//    var model: ProfileModelIteracting?
//    weak var view: ProfileViewPresenter?
//}
//
////MARK: - ProfileViewModelInput
//extension ProfileViewModel: ProfileViewModelInput {
//    
//    var isMainInfoSet: Bool {
//        guard let model = self.model else { return false }
//        return model.isMainInfoSet
//    }
//    
//    func showMenu() {
//        self.view?.showMenu()
//    }
//    
//    func signOut() {
//        self.model?.signOut()
//    }
//}
//
////MARK: - ProfileModelOutput
//extension ProfileViewModel: ProfileModelOutput {
//    
//    func succesSignedOut() {
//        self.view?.presentLoginViewController()
//    }
//    
//    func errorSignedOut(error: Error) {
//        self.view?.showErrorSignOutAlert(with: error)
//    }
//}
//
////MARK: - MenuStackViewControllerDelegate
//extension ProfileViewModel: MenuControllerDelegate {
//    
//    func menuFlowSelected(_ pushedViewController: UIViewController) {
//        guard pushedViewController is RecomendationsViewController else {
//            self.view?.pushViewControllerFromMenu(pushedViewController)
//            return
//        }
//        if self.isMainInfoSet {
//            self.view?.pushViewControllerFromMenu(pushedViewController)
//        } else {
//            self.view?.showRecomendationAlert()
//        }
//    }
//    
//    func menuSignOutPressed() {
//        self.view?.showSignOutAlert()
//    }
//}
//
