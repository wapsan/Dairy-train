import Foundation

class MeteringSetting {
    
    //MARK: - Enums
    enum WeightMode: String, Codable {
        case kg
        case lbs
    }
    
    enum HeightMode: String, Codable {
        case cm
        case ft
    }
    
    //MARK: - Singletone properties
    static let shared = MeteringSetting()
    private init () { }
    
    //MARK: - Private properties
    private var kgMultiplier: Float = 1 / 2.2
    private var lbsMultiplier: Float = 1 * 2.2
    private var cmMultiplier: Float = 1 / 0.032
    private var ftMultiplier: Float = 1 * 0.032
    
    private var kgDescription: String = "(kg.)"
    private var lbsDescription: String = "(lbs.)"
    private var cmDescription: String = "(cm.)"
    private var ftDescription: String = "(ft.)"
    
    
    //MARK: - Properties
    var weightDescription: String = ""
    var weightMultiplier: Float = 1.0
    
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
            CoreDataManager.shared.updateWeightMode(to: newValue)
            DTSettingManager.shared.setWeightMode(to: newValue)
            NotificationCenter.default.post(name: .weightMetricChanged, object: nil)
        }
    }
    
    var heightDescription: String = ""
    var heightMultiplier: Float = 1.0
    
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
            CoreDataManager.shared.updateHeightMode(to: newValue)
            DTSettingManager.shared.setHeightMode(to: newValue)
            NotificationCenter.default.post(name: .heightMetricChanged, object: nil)
        }
    }
}
