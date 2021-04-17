import Foundation
import Firebase

protocol ProfileModelProtocol: AnyObject {
    func writeNewValue(to value: String, and type: ProfileInfoCellType)
    
    var userInfo: UserInfoMO? { get }
}

protocol ProfileModelOutput: AnyObject {
    func valueWasUpdatedForCell(at index: Int)
    func heightModeWasChanged(for cellAtIndex: Int, value: String?)
    func weightModeWasChanged(for cellAtIndex: Int, value: String?)
    func trainingCountWasChanfed(to count: Int)
    func mainInfoWasUpdated()
}

final class ProfileModel {
    
    //MARK: - Internal properties
    weak var output: ProfileModelOutput?
    
    //MARK: - Private properties
    private var peristenceService: PersistenceService
    
    //MARK: - Initialization
    init(peristenceService: PersistenceService = PersistenceService()) {
        self.peristenceService =  peristenceService
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
        self.output?.weightModeWasChanged(for: ProfileInfoCellType.weight.rawValue, value: userInfo?.height.value.string)
    }
    
    @objc private func heightMetricChanged() {
        self.output?.heightModeWasChanged(for: ProfileInfoCellType.hight.rawValue, value: userInfo?.height.value.string)
    }
    
    @objc private func trainingCountWasChanged() {
        let workoutsCount = peristenceService.workout.fetchWorkouts(for: .allTime).count
        output?.trainingCountWasChanfed(to: workoutsCount)
    }
}

//MARK: - ProfileModelIteracting
extension ProfileModel: ProfileModelProtocol {
    
    var userInfo: UserInfoMO? {
        peristenceService.user.userInfo
    }

    func writeNewValue(to value: String, and type: ProfileInfoCellType) {
        switch type {
        case .totalTrain:
            break
        case .activityLevel:
            let activityLevel = UserInfo.ActivityLevel(rawValue: value)
            peristenceService.user.updateUserInfo(.activityLevel(activityLevel: activityLevel))
           
        case .gender:
            let gender = UserInfo.Gender(rawValue: value)
            peristenceService.user.updateUserInfo(.gender(gender: gender))
            
        case .age:
            peristenceService.user.updateUserInfo(.age(age: value))
            
        case .hight:
            peristenceService.user.updateUserInfo(.height(height: value))
            
        case .weight:
            peristenceService.user.updateUserInfo(.weight(weight: value))
            
        }
        self.output?.valueWasUpdatedForCell(at: type.rawValue)
    }
}
