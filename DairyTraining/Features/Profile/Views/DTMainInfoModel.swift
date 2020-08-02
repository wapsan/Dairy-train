import Foundation

protocol MainInfoModelOutput: AnyObject {
    func settingWasChanged()
    func valueWasChanged()
}

class DTMainInfoModel {
    
    weak var output: MainInfoModelOutput?
    
    //MARK: - Private properties
    var trainCountTitle: String {
        return LocalizedString.totalTrain
    }
    var ageTitle: String {
        return LocalizedString.age
    }
    
    var heightTitle: String {
        return LocalizedString.height
    }
    
    var weightTitle: String {
        return LocalizedString.weight
    }
    
    var genderTitle: String {
        return LocalizedString.gender
    }
   
    var activityLevelTitle: String {
        return LocalizedString.activityLevel
    }
    
    var totalRepsTitle: String {
        return LocalizedString.totalReps
    }
    
    var totalAproachTitle: String {
        return LocalizedString.totalAproach
    }
    
    var totalWorkoutWeightTitle: String {
        return LocalizedString.totalTrainWeight
    }
    
    var avarageWeightTitle: String {
        return LocalizedString.avarageProjectileWeigt
    }
    
    var heightMode: String? {
        return CoreDataManager.shared.readUserMainInfo()?.heightMode
    }
    
    var weightMode: String? {
        return CoreDataManager.shared.readUserMainInfo()?.weightMode
    }
    
    var totalTrainValue: String {
        return String(CoreDataManager.shared.fetchTrainingList().count)
    }
    
    var ageValue: String {
        if let age = CoreDataManager.shared.readUserMainInfo()?.age {
            return String(age)
        } else {
            return "0"
        }
    }
    
    var heightValue: String {
        guard let height = CoreDataManager.shared.readUserMainInfo()?.height else { return "0" }
        guard let heightMode = MeteringSetting.HeightMode.init(rawValue: self.heightMode ?? "0") else { return "0" }
        if heightMode == MeteringSetting.shared.heightMode {
            if height.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", height)
            } else {
                return String(format: "%.1f", height)
            }
        } else {
            let newHeigt = height * MeteringSetting.shared.heightMultiplier
            if newHeigt.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", newHeigt)
            } else {
                return String(format: "%.1f", newHeigt)
            }
        }
    }
    
    var weightValue: String {
        guard let weight = CoreDataManager.shared.readUserMainInfo()?.weight else { return "0" }
        guard let weightMode = MeteringSetting.WeightMode.init(rawValue: self.weightMode ?? "0") else { return "0" }
              if weightMode == MeteringSetting.shared.weightMode {
                  if weight.truncatingRemainder(dividingBy: 1) == 0 {
                      return String(format: "%.0f", weight)
                  } else {
                      return String(format: "%.1f", weight)
                  }
              } else {
                  let newWeight = weight * MeteringSetting.shared.weightMultiplier
                  if newWeight.truncatingRemainder(dividingBy: 1) == 0 {
                      return String(format: "%.0f", newWeight)
                  } else {
                      return String(format: "%.1f", newWeight)
                  }
              }
    }
    
    var genderValue: String {
        guard let gender = CoreDataManager.shared.readUserMainInfo()?.gender else { return "-" }
        return gender
    }
    
    var activivtyLevelValue: String {
        guard let activityLevel = CoreDataManager.shared.readUserMainInfo()?.activitylevel else {
            return "-"
        }
        return activityLevel
    }
    
    init() {
        self.addObserverForMeteringSetting()
    }
    
    private func addObserverForMeteringSetting() {
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(self.heightSettingWasChanged),
                                                  name: .heightMetricChanged,
                                                  object: nil)
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(self.weightSettingChanged),
                                                  name: .weightMetricChanged,
                                                  object: nil)
           NotificationCenter.default.addObserver(self,
                                                  selector: #selector(self.newTrainAded),
                                                  name: .trainingListWasChanged,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.valueWasChanged),
                                               name: .customAlerOkPressed,
                                               object: nil)
    }
        
    @objc private func valueWasChanged() {
        self.output?.valueWasChanged()
    }
    
    @objc private func heightSettingWasChanged() {
        self.output?.settingWasChanged()
    }
    
    @objc private func weightSettingChanged() {
        self.output?.settingWasChanged()
    }
    
    @objc private func newTrainAded() {
        self.output?.settingWasChanged()
    }
}
