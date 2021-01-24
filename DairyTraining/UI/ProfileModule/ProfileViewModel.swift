import UIKit

protocol ProfileViewModelProtocol: DTSelectionListAlertDelegate, DTValueAletDelegate {
    func selectRow(at index: Int)
}

final class ProfileViewModel {
    weak var view: ProfileViewModelPresenter?
    var model: ProfileModelProtocol
    var router: ProfileRouterProtocol?
    
    init(model: ProfileModelProtocol) {
        self.model = model
    }
}

//MARK: - ProfileViewModelInput
extension ProfileViewModel: ProfileViewModelProtocol {

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
    
    func selectionListAlertOkPressed(selectionListAlert: DTSelectionListAlert, with newValue: String?, for selectedIndex: Int) {
        guard let newValue = newValue,
            let cellType = ProfileInfoCellType.init(rawValue: selectedIndex) else { return }
        self.model.writeNewValue(to: newValue, and: cellType)
        self.view?.hideSelectionListAlert()
    }
        
    func selectionListAlertCancelPressed(selectionListAlert: DTSelectionListAlert) {
        self.view?.hideSelectionListAlert()
    }
    
    func valueAlertOkPressed(valueAlert: DTValueAlert, with newValue: String?, and selectedIndex: Int) {
        guard let newValue = newValue else { return }
        guard let cellType = ProfileInfoCellType.init(rawValue: selectedIndex) else { return }
        self.model.writeNewValue(to: newValue, and: cellType)
        self.view?.hideValueAlert()
    }
    
    func valueAlertCancelPressed(valueAlert: DTValueAlert) {
        self.view?.hideValueAlert()
    }
}


//MARK: - TestPMOutput
extension ProfileViewModel: ProfileModelOutput {

    func mainInfoWasUpdated() {
        view?.reloadData()
    }
    
    func trainingCountWasChanfed(to count: Int) {
        view?.trainingCountWasChanged(to: count)
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
