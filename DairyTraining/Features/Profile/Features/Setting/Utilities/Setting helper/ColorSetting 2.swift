import Foundation

class ColorSetting {
    
    //MARK: - Enums
    enum ColorTheme: String, CaseIterable {
        case dark = "Dark"
        case light = "Light"
    }
    
    //MARK: - Singletone Propertie
    static let shared = ColorSetting()
    
    //MARK: - Properties
    private(set) var colorTheme: ColorTheme = .dark {
        willSet {
            switch newValue {
            case .dark:
                DTSettingManager.shared.setColorTheme(to: newValue)
            case .light:
                 DTSettingManager.shared.setColorTheme(to: newValue)
            }
        }
    }
    
    //MARK: - Setter
    func setColotTheme(to theme: ColorTheme) {
        self.colorTheme = theme
    }
}


