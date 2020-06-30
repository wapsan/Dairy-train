import Foundation

class ColorSetting {
    
    //MARK: - Enums
    enum ColorTheme: String {
        case dark
        case light
    }
    
    let possibleSettingList = ["Dark", "Light"]
    let settingTitle = "Color theme"
    //MARK: - Properties
    static let shared = ColorSetting()
    
     var themeColor: ColorTheme = .dark {
        willSet {
            switch newValue {
            case .dark:
                DTSettingManager.shared.setColorTheme(to: newValue)
            case .light:
                 DTSettingManager.shared.setColorTheme(to: newValue)
            }
        }
    }
    
}


