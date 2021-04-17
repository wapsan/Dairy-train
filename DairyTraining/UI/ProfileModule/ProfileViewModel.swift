import UIKit

protocol ProfileViewModelProtocol: DTSelectionListAlertDelegate, DTValueAletDelegate {
    func selectRow(at index: IndexPath)
    func getValueFor(indexPath: IndexPath) -> String
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
    
    func getValueFor(indexPath: IndexPath) -> String {
        guard let cellType =  ProfileInfoCellType.init(rawValue: indexPath.row),
              let userInfo = model.userInfo else { return "" }
        
        switch cellType {
        case .totalTrain:
            return ""
        case .activityLevel:
            return userInfo.activityLevel ?? ""
        case .gender:
            return userInfo.gender ?? ""
        case .age:
            return userInfo.age.string
        case .hight:
            return userInfo.height.value.string
        case .weight:
            return userInfo.weight.value.string
        }
    }
    
    func selectRow(at index: IndexPath) {
        let cellType = ProfileInfoCellType.init(rawValue: index.row)
        switch cellType {
        case .age, .hight, .weight:
            self.view?.showValueAlert(for: index.row, and: getValueFor(indexPath: index))
        case .gender, .activityLevel:
            self.view?.showSelectionlistAlert(for: index.row, and: getValueFor(indexPath: index))
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
    
    func heightModeWasChanged(for cellAtIndex: Int, value: String?) {
        self.view?.updateHeightMode(for: cellAtIndex, value: value)
    }
    
    func weightModeWasChanged(for cellAtIndex: Int, value: String?) {
        self.view?.updateWeightMode(for: cellAtIndex, value: value)
    }
    
    func valueWasUpdatedForCell(at index: Int) {
        self.view?.updatValueInCell(at: index)
    }
}
