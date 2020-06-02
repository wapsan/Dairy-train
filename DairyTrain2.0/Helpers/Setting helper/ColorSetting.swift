import Foundation

class ColorSetting {
    
    //MARK: - Enums
    enum ColorTheme {
        case dark
        case light
    }
    
    //MARK: - Properties
    static let shared = ColorSetting()
    
    var themeColor: ColorTheme {
        get {
            if userDefaults.bool(forKey: UserColorThemeKey) == true {
                return .dark
            } else {
                return . light
            }
        }
        set {
            switch newValue {
            case .dark:
                userDefaults.set(true, forKey: UserColorThemeKey)
            case .light:
                userDefaults.set(false, forKey: UserColorThemeKey)
            }
        }
    }
    
}


