import Foundation

class MeteringSetting {
    
    //MARK: - Enums
    enum WeightMode {
        case kg
        case lbs
    }
    
    enum HeightMode {
        case cm
        case ft
    }
    
    //MARK: - Properties
    static let shared = MeteringSetting()
    
    
    var weightMode: WeightMode {
        get {
            if userDefaults.bool(forKey: UserWeighMetricKey) == true {
                return .kg
            } else {
                return .lbs
            }
        }
        set {
            switch newValue {
            case .kg:
                userDefaults.set(true, forKey: UserWeighMetricKey)
            case .lbs:
                userDefaults.set(false, forKey: UserWeighMetricKey)
            }
            NotificationCenter.default.post(name: .weightMetricChanged, object: nil)
        }
    }
    
    var weightDescription: String {
        get {
            switch self.weightMode {
            case .kg:
                return "(kg.)"
            case .lbs:
                return "(lbs.)"
            }
        }
        set {}
    }
    
    var weightMultiplier: Double {
        get {
            switch self.weightMode {
            case .kg:
                return (1 / 2.2)
            case .lbs:
                return (1 * 2.2)
            }
        }
    }
    
    var heightMode: HeightMode {
        get {
            if userDefaults.bool(forKey: UserHeightMetricKey) == true {
                return .cm
            } else {
                return .ft
            }
        }
        set {
            switch newValue {
            case .cm:
                userDefaults.set(true, forKey: UserHeightMetricKey)
            case .ft:
                userDefaults.set(false, forKey: UserHeightMetricKey)
            }
            NotificationCenter.default.post(name: .heightMetricChanged, object: nil)
        }
    }
    
    var heightDescription: String {
        get {
            switch self.heightMode {
            case .cm:
                return "(cm.)"
            case .ft:
                return "(ft.)"
            }
        }
        set {}
    }
    
    var heightMultiplier: Double {
        get {
            switch self.heightMode {
            case .cm:
                return (1 / 0.032)
            case .ft:
                return (1 * 0.032)
            }
        }
    }
    
}
