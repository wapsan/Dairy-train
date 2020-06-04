import Foundation

class DTSettingManager {
    
    static let shared = DTSettingManager()
    
    private func setDefaultWeightMode() {
        if UserDefaults.standard.value(forKey: UserWeighMetricKey) == nil {
            MeteringSetting.shared.weightMode = .kg
        }
        if UserDefaults.standard.bool(forKey: UserWeighMetricKey) == true {
            MeteringSetting.shared.weightMode = .kg
        } else {
            MeteringSetting.shared.weightMode = .lbs
        }
    }
    
    private func setDefaultHeightMode() {
        if UserDefaults.standard.value(forKey: UserHeightMetricKey) == nil {
            MeteringSetting.shared.heightMode = .cm
        }
        if UserDefaults.standard.bool(forKey: UserHeightMetricKey) == true {
            MeteringSetting.shared.heightMode = .cm
        } else {
            MeteringSetting.shared.heightMode = .ft
        }
    }
    
    private func setDefaultColorTheme() {
        if UserDefaults.standard.value(forKey: UserColorThemeKey) == nil {
            ColorSetting.shared.themeColor = .dark
        }
        if UserDefaults.standard.bool(forKey: UserColorThemeKey) == true {
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
    
}
