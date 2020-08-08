import UIKit

protocol TestPVMInput: AnyObject {
    func selectRow(at index: Int)
    func signOut()
    func showMenu()
    
    var isMainInfoSet: Bool { get }
}

protocol TestPVCPresenter: AnyObject {
    func updatCell(at index: Int)
    func showValueAlert(for selectedIndex: Int, and value: String?)
    func hideaAlert()
    func updateHeightMode(for cellAtIndex: Int)
    func updateWeightMode(for cellAtIndex: Int)
    
    func showRecomendationAlert()
    func showMenu()
    func showSignOutAlert()
    func presentLoginViewController()
    func showErrorSignOutAlert(with error: Error)
    func pushViewControllerFromMenu(_ viewController: UIViewController)
}

final class TestPVM {
    
    weak var view: TestPVCPresenter?
    var model: TestPMIterating?
}

extension TestPVM: TestPVMInput {
    
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
        let cellType = MainInfoCellType.init(rawValue: index)
        self.view?.showValueAlert(for: index, and: cellType?.value)
    }
}

extension TestPVM: DTValueAletDelegate {
    
    func valueAlertOkPressed(valueAlert: DTValueAlert, with newValue: String?, and selectedIndex: Int) {
        guard let newValue = newValue else { return }
        guard let cellType = MainInfoCellType.init(rawValue: selectedIndex) else { return }
        self.model?.writeNewValue(to: newValue, and: cellType)
        self.view?.hideaAlert()
    }
    
    func valueAlertCancelPressed(valueAlert: DTValueAlert) {
        self.view?.hideaAlert()
    }
}

//MARK: - MenuControllerDelegate
extension TestPVM: MenuControllerDelegate {
    
    func menuFlowSelected(_ pushedViewController: UIViewController) {
        guard pushedViewController is RecomendationsViewController else {
            self.view?.pushViewControllerFromMenu(pushedViewController)
            return
        }
        if self.isMainInfoSet {
            self.view?.pushViewControllerFromMenu(pushedViewController)
        } else {
            self.view?.showRecomendationAlert()
        }
    }
    
    func menuSignOutPressed() {
        self.view?.showSignOutAlert()
    }
}

//MARK: - TestPMOutput
extension TestPVM: TestPMOutput {
   
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
        self.view?.updatCell(at: index)
    }
}
