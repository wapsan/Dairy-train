import UIKit

protocol MainInfoViewModelIteracting {
    var description: String? { get }
    var value: String? { get }
    var title: String? { get }
    var backgroundImage: UIImage? { get }
}

class DTMainInfoViewModel {
    
    //MARK: - Properties
    weak var view: DTMainInfoViewPresenter?
    var model: DTMainInfoModel?

}

//MARK: - MainInfoModelOutput
extension DTMainInfoViewModel: MainInfoModelOutput {
    
    func valueWasChanged() {
        self.view?.updateUI()
    }
    
    func settingWasChanged() {
        self.view?.updateUI()
    }
}

//MARK: - MainInfoViewModelIteracting
extension DTMainInfoViewModel: MainInfoViewModelIteracting {
    
    var description: String? {
        guard let viewType = self.view?.type else {
            return nil
        }
        switch viewType {
        case .weight:
            return MeteringSetting.shared.weightDescription
        case .height:
            return MeteringSetting.shared.heightDescription
        default:
            return nil
        }
    }
    
    var backgroundImage: UIImage? {
        guard let viewType = self.view?.type else {
            return nil
        }
        switch viewType {
            
        case .trainCount:
            return UIImage.totalTraininBackgroundImage
        case .gender:
            return UIImage.genderBackgroundImage
        case .activityLevel:
            return UIImage.activityLevelBackgroundImage
        case .age:
            return UIImage.ageBackgroundImage
        case .height:
            return UIImage.heightBackgroundImage
        case .weight:
            return UIImage.weightBackgroundImage
        case .totalReps:
            return UIImage.totalRepsBackgroundImage
        case .totalAproach:
            return UIImage.totalAproachBackgroundImage
        case .avarageProjectileWeight:
            return UIImage.avareProjectileWeightBackgroundImage
        case .totalWeight:
            return UIImage.totalTrainingWeightbackgroundImage
        }
    }
    
    var value: String? {
        guard let viewType = self.view?.type else {
            return nil
        }
        switch viewType {
        case .trainCount:
            return self.model?.totalTrainValue
        case .gender:
            return self.model?.genderValue
        case .activityLevel:
            return self.model?.activivtyLevelValue
        case .age:
            return self.model?.ageValue
        case .height:
            return self.model?.heightValue
        case .weight:
            return self.model?.weightValue
        case .totalReps:
            return nil
        case .totalAproach:
            return nil
        case .avarageProjectileWeight:
            return nil
        case .totalWeight:
            return nil
        }
    }
    
    var title: String? {
        guard let viewType = self.view?.type else {
            return nil
        }
        switch viewType {
        case .trainCount:
            return LocalizedString.totalTrain
        case .gender:
            return LocalizedString.gender
        case .activityLevel:
            return LocalizedString.activityLevel
        case .age:
            return LocalizedString.age
        case .height:
            return LocalizedString.height
        case .weight:
            return LocalizedString.weight
        case .totalReps:
            return LocalizedString.totalReps
        case .totalAproach:
            return LocalizedString.totalAproach
        case .avarageProjectileWeight:
            return LocalizedString.avarageProjectileWeigt
        case .totalWeight:
            return LocalizedString.totalTrainWeight
        }
    }
}
