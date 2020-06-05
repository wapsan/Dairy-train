import Foundation

class DTSettingManager {
    
    static let shared = DTSettingManager()
    
    struct UserSettingKeys {
        static let tokenKey = "Token"
        static let colorThemeKey = "Color"
        static let weighMetricKey = "Weight metric"
        static let heightMetricKey = "Height metric"
    }
    
    
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
    
    func activateDefaultSetting() {
        self.setDefaultWeightMode()
        self.setDefaultHeightMode()
        self.setDefaultColorTheme()
    }
    
    func setWeight(mode: MeteringSetting.WeightMode) {
        print("Weight mode set to \(mode).")
        switch mode {
        case .kg:
            userDefaults.set(true, forKey: UserWeighMetricKey)
        case .lbs:
            userDefaults.set(false, forKey: UserWeighMetricKey)
        }
    }
    
    func setHeight(mode: MeteringSetting.HeightMode) {
        print("Height mode set to \(mode).")
        switch mode {
        case .cm:
             userDefaults.set(true, forKey: UserHeightMetricKey)
        case .ft:
             userDefaults.set(false, forKey: UserHeightMetricKey)
        }
    }
    
    func setColor(theme: ColorSetting.ColorTheme) {
        print("Color theme set to \(theme).")
        switch theme {
        case .dark:
            userDefaults.set(true, forKey: UserColorThemeKey)
        case .light:
            userDefaults.set(false, forKey: UserColorThemeKey)
        }
    }
    
    func setUserToken(to token: String) {
        UserDefaults.standard.set(token, forKey: UserSettingKeys.tokenKey)
        print("User tokent was set to - \(token)")
    }
    
    func getUserToken() -> String? {
        guard let userToken = UserDefaults.standard.string(forKey: UserSettingKeys.tokenKey) else {
            return nil
        }
        return userToken
    }
    
}
