import Foundation

class MeteringSetting {
    
    //MARK: - Enums
    enum WeightMode {
        case kg
        case lbs
     
    }
    
    enum HeightMode: String {
        case cm
        case ft
    }
    
    //MARK: - Singletone properties
    static let shared = MeteringSetting()
    
    //MARK: - Private properties
    private var kgMultiplier: Double = 1 / 2.2
    private var lbsMultiplier: Double = 1 * 2.2
    private var cmMultiplier: Double = 1 / 0.032
    private var ftMultiplier: Double = 1 * 0.032
    
    private var kgDescription: String = "(kg.)"
    private var lbsDescription: String = "(lbs.)"
    private var cmDescription: String = "(cm.)"
    private var ftDescription: String = "(ft.)"
    
    
    //MARK: - Properties
    var weightDescription: String = ""
    var weightMultiplier: Double = 1.0
    
    var weightMode: WeightMode = .kg {
        willSet {
            switch newValue {
            case .kg:
                self.weightMultiplier = self.kgMultiplier
                self.weightDescription = self.kgDescription
            case .lbs:
                self.weightMultiplier = self.lbsMultiplier
                self.weightDescription = self.lbsDescription
            }
            DTSettingManager.shared.setWeight(mode: newValue)
            NotificationCenter.default.post(name: .weightMetricChanged, object: nil)
        }
    }
    
    var heightDescription: String = ""
    var heightMultiplier: Double = 1.0
    
    var heightMode: HeightMode = .cm {
        willSet {
            switch newValue {
            case .cm:
                self.heightMultiplier = self.cmMultiplier
                self.heightDescription = self.cmDescription
            case .ft:
                self.heightMultiplier = self.ftMultiplier
                self.heightDescription = self.ftDescription
            }
            DTSettingManager.shared.setHeight(mode: newValue)
            NotificationCenter.default.post(name: .heightMetricChanged, object: nil)
        }
    }
    
}
