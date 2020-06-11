import Foundation

class ColorSetting {
    
    //MARK: - Enums
    enum ColorTheme {
        case dark
        case light
    }
    
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


