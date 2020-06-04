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
                DTSettingManager.shared.setColor(theme: newValue)
            case .light:
                 DTSettingManager.shared.setColor(theme: newValue)
            }
        }
    }
    
}


