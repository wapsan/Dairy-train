import Foundation

class SettingModel {
    
    //MARK: - Enums
    enum SettingType {
        case colorTheme
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
            case .colorTheme:
                if currentValue == ColorSetting.ColorTheme.dark.rawValue {
                    ColorSetting.shared.setColotTheme(to: .dark)
                } else {
                    ColorSetting.shared.setColotTheme(to: .light)
                }
            case .weightMetric:
                if currentValue == MeteringSetting.WeightMode.kg.rawValue {
                    MeteringSetting.shared.setWeightMode(to: .kg)
                } else {
                    MeteringSetting.shared.setWeightMode(to: .lbs)
                }
                NotificationCenter.default.post(name: .weightMetricChanged, object: nil)
            case .heightMetric:
                if currentValue == MeteringSetting.HeightMode.cm.rawValue {
                    MeteringSetting.shared.setHeightMode(to: .cm)
                } else {
                    MeteringSetting.shared.setHeightMode(to: .ft)
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
        case .colorTheme:
            self.title = LocalizedString.colorTheme
            self.sectionTitle = LocalizedString.theme
            for theme in ColorSetting.ColorTheme.allCases {
                self.possibleSetting.append(theme.rawValue)
            }
            self.currentValue = ColorSetting.shared.colorTheme.rawValue
        case .weightMetric:
            self.title = LocalizedString.weightMode
            self.sectionTitle = LocalizedString.mode
            for mode in MeteringSetting.WeightMode.allCases {
                self.possibleSetting.append(mode.rawValue)
            }
            self.currentValue = MeteringSetting.shared.weightMode.rawValue
        case .heightMetric:
            self.title = LocalizedString.heightMode
            self.sectionTitle = LocalizedString.mode
            for mode  in MeteringSetting.HeightMode.allCases {
                self.possibleSetting.append(mode.rawValue)
            }
            self.currentValue = MeteringSetting.shared.heightMode.rawValue
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
