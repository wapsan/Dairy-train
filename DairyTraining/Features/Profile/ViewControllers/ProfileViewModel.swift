import Foundation

class ProfileViewModel {
    
    //MARK: - Properties
    var model: ProfileModel!
    var viewPresenter: ProfileViewPresenter!
    
    //MARK: - Public methods
    func signOut() {
        self.model.signOut()
    }
}

//MARK: - Model delegate
extension ProfileViewModel: ProfileModelDelegate {
    
    func succesSignedOut() {
        self.viewPresenter.presentLoginViewController()
    }
    
    func errorSignedOut(error: Error) {
        self.viewPresenter.showErrorSignOutAlert(with: error)
    }
}
