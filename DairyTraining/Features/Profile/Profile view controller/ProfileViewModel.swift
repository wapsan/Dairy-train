import UIKit

protocol ProfileViewModelInput: AnyObject {
    func selectRow(at index: Int)
    func signOut()
    func showMenu()
    var isMainInfoSet: Bool { get }
}

protocol ProfileViewModelPresenter: AnyObject {
    func updatValueInCell(at index: Int)
    func showValueAlert(for selectedIndex: Int, and value: String?)
    func hideValueAlert()
    func showSelectionlistAlert(for selectedIndex: Int, and value: String?)
    func hideSelectionListAlert()
    func updateHeightMode(for cellAtIndex: Int)
    func updateWeightMode(for cellAtIndex: Int)
    
    func showRecomendationAlert()
    func showMenu()
    func showSignOutAlert()
    func presentLoginViewController()
    func showErrorSignOutAlert(with error: Error)
    func pushViewControllerFromMenu(_ viewController: UIViewController)
}

final class ProfileViewModel {
    weak var view: ProfileViewModelPresenter?
    var model: ProfileModelIteracting?
}

//MARK: - ProfileViewModelInput
extension ProfileViewModel: ProfileViewModelInput {
    
    func signOut() {
        self.model?.signOut()
    }
    
    func showMenu() {
        self.view?.showMenu()
    }
    
    var isMainInfoSet: Bool {
        guard let model = self.model else { return false }
        return model.isMainInfoSet
    }
    
    func selectRow(at index: Int) {
        let cellType = ProfileInfoCellType.init(rawValue: index)
        switch cellType {
        case .age, .hight, .weight:
            self.view?.showValueAlert(for: index, and: cellType?.value)
        case .gender, .activityLevel:
            self.view?.showSelectionlistAlert(for: index, and: cellType?.value)
        default:
            break
        }
    }
}

//MARK: - DTValueAletDelegate
extension ProfileViewModel: DTValueAletDelegate {
    
    func valueAlertOkPressed(valueAlert: DTValueAlert, with newValue: String?, and selectedIndex: Int) {
        guard let newValue = newValue else { return }
        guard let cellType = ProfileInfoCellType.init(rawValue: selectedIndex) else { return }
        self.model?.writeNewValue(to: newValue, and: cellType)
        self.view?.hideValueAlert()
    }
    
    func valueAlertCancelPressed(valueAlert: DTValueAlert) {
        self.view?.hideValueAlert()
    }
}

//MARK: - DTSelectionListAlertDelegate
extension ProfileViewModel: DTSelectionListAlertDelegate {
    
    func selectionListAlertOkPressed(selectionListAlert: DTSelectionListAlert, with newValue: String?, for selectedIndex: Int) {
        guard let newValue = newValue,
            let cellType = ProfileInfoCellType.init(rawValue: selectedIndex) else { return }
        self.model?.writeNewValue(to: newValue, and: cellType)
        self.view?.hideSelectionListAlert()
    }
        
    func selectionListAlertCancelPressed(selectionListAlert: DTSelectionListAlert) {
        self.view?.hideSelectionListAlert()
    }
}

//MARK: - MenuControllerDelegate
extension ProfileViewModel: MenuControllerDelegate {
    
    func pushStatisticsFlow(statisticsViewController: UIViewController) {
        self.view?.pushViewControllerFromMenu(statisticsViewController)
    }
    
    func pushSettingFlow(settingviewController: UIViewController) {
        self.view?.pushViewControllerFromMenu(settingviewController)
    }
    
    func pushRecomendationFlow(recomendationViewController: UIViewController) {
        if self.isMainInfoSet {
            self.view?.pushViewControllerFromMenu(recomendationViewController)
        } else {
            self.view?.showRecomendationAlert()
        }
    }

    func menuSignOutPressed() {
        self.view?.showSignOutAlert()
    }
}

//MARK: - TestPMOutput
extension ProfileViewModel: ProfileModelOutput {
   
    func succesSignedOut() {
        self.view?.presentLoginViewController()
    }
    
    func errorSignedOut(error: Error) {
        self.view?.showErrorSignOutAlert(with: error)
    }
    
    func heightModeWasChanged(for cellAtIndex: Int) {
        self.view?.updateHeightMode(for: cellAtIndex)
    }
    
     func weightModeWasChanged(for cellAtIndex: Int) {
        self.view?.updateWeightMode(for: cellAtIndex)
    }
    
    func valueWasUpdatedForCell(at index: Int) {
        self.view?.updatValueInCell(at: index)
    }
}
