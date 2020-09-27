import Foundation
import Firebase

protocol ProfileModelIteracting: AnyObject {
    func writeNewValue(to value: String, and type: ProfileInfoCellType)
    func signOut()
    var isMainInfoSet: Bool { get }
}

protocol ProfileModelOutput: AnyObject {
    func valueWasUpdatedForCell(at index: Int)
    func heightModeWasChanged(for cellAtIndex: Int)
    func weightModeWasChanged(for cellAtIndex: Int)
    func succesSignedOut()
    func errorSignedOut(error: Error)
}

final class ProfileModel {
   
    weak var output: ProfileModelOutput?
    
    init() {
        self.addObserverForHeightModeChanged()
        self.addObserverForWeightSettingChanged()
    }
    
    private func addObserverForHeightModeChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.heightMetricChanged),
                                               name: .heightMetricChanged,
                                               object: nil)
    }
    
    private func addObserverForWeightSettingChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.weightMetricWasChanged),
                                               name: .weightMetricChanged,
                                               object: nil)
    }
    
    @objc private func weightMetricWasChanged() {
        self.output?.weightModeWasChanged(for: ProfileInfoCellType.weight.rawValue) 
    }
    
    @objc private func heightMetricChanged() {
        self.output?.heightModeWasChanged(for: ProfileInfoCellType.hight.rawValue)
    }
}

//MARK: - ProfileModelIteracting
extension ProfileModel: ProfileModelIteracting {
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DTSettingManager.shared.deleteUserToken()
            CoreDataManager.shared.removeAllUserData { [weak self] in
                guard let self = self else { return }
                self.output?.succesSignedOut()
            }
        } catch let signOutError {
            self.output?.errorSignedOut(error: signOutError)
        }
    }
    
    var isMainInfoSet: Bool {
        guard let userMainInfo = CoreDataManager.shared.readUserMainInfo() else {
            return false
        }
        return userMainInfo.isSet
    }
    
    func writeNewValue(to value: String, and type: ProfileInfoCellType) {
        switch type {
        case .totalTrain:
            break
        case .activityLevel:
            if let activityLevel = UserMainInfoCodableModel.ActivityLevel.init(rawValue: value) {
                CoreDataManager.shared.updateActivityLevel(to: activityLevel)
            }
        case .gender:
            if let gender = UserMainInfoCodableModel.Gender.init(rawValue: value) {
                CoreDataManager.shared.updateGender(to: gender)
            }
        case .age:
            if let age = Int(value) {
               CoreDataManager.shared.updateAge(to: age)
            }
        case .hight:
            if let height = Float(value) {
                CoreDataManager.shared.updateHeight(to: height)
            }
        case .weight:
            if let weight = Float(value) {
                CoreDataManager.shared.updateWeight(to: weight)
            }
        }
        self.output?.valueWasUpdatedForCell(at: type.rawValue)
    }
}
