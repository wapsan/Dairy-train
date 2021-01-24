import Foundation
import Firebase

protocol ProfileModelProtocol: AnyObject {
    func writeNewValue(to value: String, and type: ProfileInfoCellType)
}

protocol ProfileModelOutput: AnyObject {
    func valueWasUpdatedForCell(at index: Int)
    func heightModeWasChanged(for cellAtIndex: Int)
    func weightModeWasChanged(for cellAtIndex: Int)
    func trainingCountWasChanfed(to count: Int)
    func mainInfoWasUpdated()
}

final class ProfileModel {
   
    weak var output: ProfileModelOutput?
    
    init() {
        addObserverForHeightModeChanged()
        addObserverForWeightSettingChanged()
        addObserverForTrainingCountChanged()
        addObserverForMainInfo()
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
    
    private func addObserverForTrainingCountChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingCountWasChanged),
                                               name: .trainingListWasChanged,
                                               object: nil)
    }
    
    private func addObserverForMainInfo() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mainInfoWasUpdateAction),
                                               name: .mainInfoWasUpdated,
                                               object: nil)
    }
    
    
    @objc private func mainInfoWasUpdateAction() {
        self.output?.mainInfoWasUpdated()
    }
    
    @objc private func weightMetricWasChanged() {
        self.output?.weightModeWasChanged(for: ProfileInfoCellType.weight.rawValue) 
    }
    
    @objc private func heightMetricChanged() {
        self.output?.heightModeWasChanged(for: ProfileInfoCellType.hight.rawValue)
    }
    
    @objc private func trainingCountWasChanged() {
        output?.trainingCountWasChanfed(to: TrainingDataManager.shared.getTraingList().count)
    }
}

//MARK: - ProfileModelIteracting
extension ProfileModel: ProfileModelProtocol {
    
    func writeNewValue(to value: String, and type: ProfileInfoCellType) {
        switch type {
        case .totalTrain:
            break
        case .activityLevel:
            if let activityLevel = UserMainInfoCodableModel.ActivityLevel.init(rawValue: value) {
                UserDataManager.shared.updateActivityLevel(to: activityLevel)
            }
        case .gender:
            if let gender = UserMainInfoCodableModel.Gender.init(rawValue: value) {
                UserDataManager.shared.updateGender(to: gender)
            }
        case .age:
            if let age = Int(value) {
               UserDataManager.shared.updateAge(to: age)
            }
        case .hight:
            if let height = Float(value) {
                UserDataManager.shared.updateHeight(to: height)
            }
        case .weight:
            if let weight = Float(value) {
                UserDataManager.shared.updateWeight(to: weight)
            }
        }
        self.output?.valueWasUpdatedForCell(at: type.rawValue)
    }
}
