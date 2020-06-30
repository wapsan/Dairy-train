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
    private lazy var kgMultiplier: Float = 1 / 2.2
    private lazy var lbsMultiplier: Float = 1 * 2.2
    private lazy var cmMultiplier: Float = 1 * 0.032
    private lazy var ftMultiplier: Float = 1 / 0.032
    
    private lazy var kgDescription: String = " Kg."
    private lazy var lbsDescription: String = " Lbs."
    private lazy var cmDescription: String = " Cm."
    private lazy var ftDescription: String = " Ft."
    
    
    //MARK: - Properties
    var weightMultiplier: Float {
        switch self.weightMode {
        case .kg:
            return self.kgMultiplier
        case .lbs:
            return self.lbsMultiplier
        }
    }
    
    var weightDescription: String {
        switch self.weightMode {
        case .kg:
           return self.kgDescription
        case .lbs:
           return self.lbsDescription
        }
    }
    
    var weightMode: WeightMode = .kg {
        willSet {
          
            DTSettingManager.shared.setWeightMode(to: newValue)
        }
        didSet {
         //   CoreDataManager.shared.updateWeightMode(to: self.weightMode)
          //  DTFirebaseFileManager.shared.updateMainUserInfoInFirebase()
         //   NotificationCenter.default.post(name: .weightMetricChanged, object: nil)
        }//
    }
    
    var heightDescription: String {
        switch self.heightMode {
        case .cm:
            return self.cmDescription
        case .ft:
            return self.ftDescription
        }
    }
    var heightMultiplier: Float {
        switch self.heightMode {
        case .cm:
            return self.cmMultiplier
        case .ft:
            return self.ftMultiplier
        }
    }
    
    var heightMode: HeightMode = .cm {
        willSet {
            
            DTSettingManager.shared.setHeightMode(to: newValue)
        }
        didSet {
           // CoreDataManager.shared.updateHeightMode(to: self.heightMode)
          //  DTFirebaseFileManager.shared.updateMainUserInfoInFirebase()
           // NotificationCenter.default.post(name: .heightMetricChanged, object: nil)
        }
    }
}
