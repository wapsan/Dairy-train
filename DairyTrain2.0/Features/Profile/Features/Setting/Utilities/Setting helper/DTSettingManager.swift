import Foundation

class DTSettingManager {
    
    //MARK: - Singletone propetie
    static let shared = DTSettingManager()
    private init() { }
    //MARK: - Private properties
    private var userDefaults = UserDefaults.standard
    
    //MARK: - Enum setting key
    struct UserSettingKeys {
        static let tokenKey = "Token"
        static let colorThemeKey = "Color"
        static let weighMetricKey = "Weight metric"
        static let heightMetricKey = "Height metric"
    }
    
    //MARK: - Private methods
    private func setDefaultWeightMode() {
        if UserDefaults.standard.value(forKey: UserSettingKeys.weighMetricKey) == nil {
            MeteringSetting.shared.weightMode = .kg
        }
        if UserDefaults.standard.bool(forKey: UserSettingKeys.weighMetricKey) == true {
            MeteringSetting.shared.weightMode = .kg
        } else {
            MeteringSetting.shared.weightMode = .lbs
        }
    }
    
    private func setDefaultHeightMode() {
        if UserDefaults.standard.value(forKey: UserSettingKeys.heightMetricKey) == nil {
            MeteringSetting.shared.heightMode = .cm
        }
        if UserDefaults.standard.bool(forKey: UserSettingKeys.heightMetricKey) == true {
            MeteringSetting.shared.heightMode = .cm
        } else {
            MeteringSetting.shared.heightMode = .ft
        }
    }
    
    private func setDefaultColorTheme() {
        if UserDefaults.standard.value(forKey: UserSettingKeys.colorThemeKey) == nil {
            ColorSetting.shared.themeColor = .dark
        }
        if UserDefaults.standard.bool(forKey: UserSettingKeys.colorThemeKey) == true {
            ColorSetting.shared.themeColor = .dark
        } else {
            ColorSetting.shared.themeColor = .light
        }
    }
    
    //MARK: - Public methods
    func activateDefaultSetting() {
        self.setDefaultWeightMode()
        self.setDefaultHeightMode()
        self.setDefaultColorTheme()
    }
    
    func setWeightMode(to mode: MeteringSetting.WeightMode) {
        print("Weight mode set to \(mode).")
        switch mode {
        case .kg:
            self.userDefaults.set(true, forKey: UserSettingKeys.weighMetricKey)
        case .lbs:
            self.userDefaults.set(false, forKey: UserSettingKeys.weighMetricKey)
        }
    }
    
    func setHeightMode(to mode: MeteringSetting.HeightMode) {
        print("Height mode set to \(mode).")
        switch mode {
        case .cm:
            self.userDefaults.set(true, forKey: UserSettingKeys.heightMetricKey)
        case .ft:
             self.userDefaults.set(false, forKey: UserSettingKeys.heightMetricKey)
        }
    }
    
    func setColorTheme(to theme: ColorSetting.ColorTheme) {
        print("Color theme set to \(theme).")
        switch theme {
        case .dark:
            self.userDefaults.set(true, forKey: UserSettingKeys.colorThemeKey)
        case .light:
            self.userDefaults.set(false, forKey: UserSettingKeys.colorThemeKey)
        }
    }
    
    func setUserToken(to token: String) {
        self.userDefaults.set(token, forKey: UserSettingKeys.tokenKey)
        print("User tokent was set to - \(token)")
    }
    
    func deleteUserToken() {
        self.userDefaults.removeObject(forKey: UserSettingKeys.tokenKey)
    }
    
    func getUserToken() -> String? {
        return self.userDefaults.string(forKey: UserSettingKeys.tokenKey)
    }
}
