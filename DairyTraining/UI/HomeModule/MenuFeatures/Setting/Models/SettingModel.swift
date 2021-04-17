import Foundation

class SettingModel {
    
    //MARK: - Enums
    enum SettingType {
     //   case colorTheme
        case weightMetric
        case heightMetric
        case synchronization
    }
    
    //MARK: - Properties
    var possibleSetting: [String] = []
    var title: String
    var sectionTitle: String?
    var settingType: SettingType
    
    var currentValue: String? {
        didSet {
            guard let currentValue = self.currentValue else { return }
            switch self.settingType {
          
            case .weightMetric:
                if currentValue == UserInfo.WeightMode.kg.rawValue {
                    UserDefaults.standard.setWeightMode(weightMode: .kg)
                } else {
                    UserDefaults.standard.setWeightMode(weightMode: .lbs)
                }
                NotificationCenter.default.post(name: .weightMetricChanged, object: nil)
            case .heightMetric:
                if currentValue == UserInfo.HeightMode.cm.rawValue {
                    UserDefaults.standard.setHegithMode(heightMode: .cm)
                } else {
                    UserDefaults.standard.setHegithMode(heightMode: .ft)
                }
                NotificationCenter.default.post(name: .heightMetricChanged, object: nil)
            case .synchronization:
                break
            }
        }
    }
    
    //MARK: - Initialization
    init(for settingType: SettingType) {
        self.settingType = settingType
        switch settingType {
//        case .colorTheme:
//            self.title = LocalizedString.colorTheme
//            self.sectionTitle = LocalizedString.theme
//            for theme in ColorSetting.ColorTheme.allCases {
//                self.possibleSetting.append(theme.rawValue)
//            }
//            self.currentValue = ColorSetting.shared.colorTheme.rawValue
        case .weightMetric:
            self.title = LocalizedString.weightMode
            self.sectionTitle = LocalizedString.mode
            for mode in UserInfo.WeightMode.allCases {
                self.possibleSetting.append(mode.rawValue)
            }
            self.currentValue = UserDefaults.standard.weightMode.rawValue
        case .heightMetric:
            self.title = LocalizedString.heightMode
            self.sectionTitle = LocalizedString.mode
            for mode  in UserInfo.HeightMode.allCases {
                self.possibleSetting.append(mode.rawValue)
            }
            self.currentValue = UserDefaults.standard.heightMode.rawValue
        case .synchronization:
            self.title = LocalizedString.synhronization
        }
    }
    
    //MARK: - Public methods
    func isSettingSelected(at index: Int) -> Bool {
        guard let currentValue = self.currentValue else { return false }
        switch self.settingType {
        case .synchronization:
            return false
        default:
            if currentValue == self.possibleSetting[index] {
                return true
            } else {
                return false
            }
        }
    }
}
