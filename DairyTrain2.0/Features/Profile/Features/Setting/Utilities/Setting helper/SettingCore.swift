import Foundation

enum SettingSectionType {
    case metrics
    case style
}

enum SettingType {
    case colorTheme
    case weightMetric
    case heightMetric
}

class SettingSection {
    
    //MARK: - Properties
    var tittle: String
    var settings: [Setting]
    
    //MARK: - Initialization
    init(type: SettingSectionType) {
        switch type {
        case .metrics:
            self.tittle = "Metric"
            self.settings = [Setting(type: .weightMetric),
                             Setting(type: .heightMetric)]
        case .style:
            self.tittle = "Style"
            self.settings = [Setting(type: .colorTheme)]
        }
    }
    
}
   
class Setting {
    
    //MARK: - Properties
    var header: String
    var type: SettingType?
    var tittle: String
    var possibleList: [String]
    var possibleSetting: [String]
    
    
    var curenttValue: String? {
        didSet {
            guard let settingType = self.type else { return }
            switch settingType {
            case .colorTheme:
                if curenttValue == "dark" {
                    ColorSetting.shared.themeColor = .dark
                } else if curenttValue == "light" {
                    ColorSetting.shared.themeColor = .light
                } else {
                    ColorSetting.shared.themeColor = .dark
                }
            case .weightMetric:
                if curenttValue == "kg." {
                    MeteringSetting.shared.weightMode = .kg
                } else  if curenttValue == "lbs." {
                    MeteringSetting.shared.weightMode = .lbs
                } else {
                    MeteringSetting.shared.weightMode = .kg
                }
            case .heightMetric:
                if curenttValue == "cm." {
                    MeteringSetting.shared.heightMode = .cm
                } else if curenttValue == "ft." {
                    MeteringSetting.shared.heightMode = .ft
                } else {
                    MeteringSetting.shared.heightMode = .cm
                }
            }
        }
    }
    
    //MARK: - Publick methods
    func isChekedIn(_ index: Int) -> Bool {
        guard let settingType = self.type else { return false}
        switch settingType {
        case .colorTheme:
            if self.curenttValue == "dark" && self.possibleList[index] == "Dark" {
                return true
            } else if self.curenttValue == "light" && self.possibleList[index] == "Light" {
                return true
            } else  {
                return false
            }
        case .weightMetric:
            if self.curenttValue == "kg." && self.possibleList[index] == "Kilograms / kg." {
                return true
            } else  if self.curenttValue == "lbs." && self.possibleList[index] == "Pounds / lbs." {
                return true
            } else {
                return false
            }
        case .heightMetric:
            if self.curenttValue == "cm." && self.possibleList[index] == "Сentimeters" {
                return true
            } else if self.curenttValue == "ft." && self.possibleList[index] == "Feet" {
                return true
            } else {
                return false
            }
        }
    }
    
    //MARK: - Initialization
    init(type: SettingType) {
        self.type = type
        switch type {
        case .colorTheme:
            self.header = "Theme"
            self.tittle = "Color theme"
            self.possibleList = ["Dark", "Light"]
            self.possibleSetting = ["dark", "light"]
            
            if ColorSetting.shared.themeColor == .dark {
                self.curenttValue = "dark"
            } else {
                self.curenttValue = "light"
            }
        case .weightMetric:
            self.header = "Metric"
            self.tittle = "Weight metric"
            self.possibleList = ["Kilograms / kg.", "Pounds / lbs."]
            self.possibleSetting = ["kg.","lbs."]
            
            if MeteringSetting.shared.weightMode == .kg {
                self.curenttValue = "kg."
            } else {
                self.curenttValue = "lbs."
            }
        case .heightMetric:
            self.header = "Metric"
            self.tittle = "Height metric"
            self.possibleList = ["Feet","Сentimeters"]
            self.possibleSetting = ["ft.","cm."]
            
            if MeteringSetting.shared.heightMode == .cm {
                self.curenttValue = "cm."
            } else {
                self.curenttValue = "ft."
            }
        }
    }
    
}
