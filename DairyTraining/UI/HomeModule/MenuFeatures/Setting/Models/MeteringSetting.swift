//import Foundation
//
//class MeteringSetting {
//    
//    //MARK: - Singletone properties
//    static let shared = MeteringSetting()
//    private init () { }
//    
//    //MARK: - Private properties
//    private lazy var kgMultiplier: Float = 1 / 2.2
//    private lazy var lbsMultiplier: Float = 1 * 2.2
//    private lazy var cmMultiplier: Float = 1 / 0.032
//    private lazy var ftMultiplier: Float = 1 * 0.032
//    
//    private lazy var kgDescription: String = LocalizedString.kgDescription
//    private lazy var lbsDescription: String = LocalizedString.lbsDescription
//    private lazy var cmDescription: String = LocalizedString.cmDescription
//    private lazy var ftDescription: String = LocalizedString.ftDescription
//    
//    //MARK: - Properties
//    var weightMultiplier: Float {
//        switch self.weightMode {
//        case .kg:
//            return self.kgMultiplier
//        case .lbs:
//            return self.lbsMultiplier
//        }
//    }
//    
//    var weightDescription: String {
//        switch self.weightMode {
//        case .kg:
//            return self.kgDescription
//        case .lbs:
//            return self.lbsDescription
//        }
//    }
//    
//    private(set) var weightMode: WeightMode = .kg {
//        willSet {
//            SettingManager.shared.setWeightMode(to: newValue)
//        }
//    }
//    
//    var heightDescription: String {
//        switch self.heightMode {
//        case .cm:
//            return self.cmDescription
//        case .ft:
//            return self.ftDescription
//        }
//    }
//    
//    var heightMultiplier: Float {
//        switch self.heightMode {
//        case .cm:
//            return self.cmMultiplier
//        case .ft:
//            return self.ftMultiplier
//        }
//    }
//    
//    private(set) var heightMode: UserInfo.HeightMode = .cm {
//        willSet {
//            SettingManager.shared.setHeightMode(to: newValue)
//        }
//    }
//    
//    func getWeight(for weight: Float, and aproachWeightMode: WeightMode) -> Double {
//        var weightMultiplier: Float = 1
//        if aproachWeightMode != weightMode {
//            weightMultiplier = self.weightMultiplier
//        }
//        let correctWeight = Double(weight) * Double(weightMultiplier)
//        return correctWeight
//    }
//    
//    //MARK: - Setters
//    func setWeightMode(to mode: WeightMode) {
//        self.weightMode = mode
//    }
//    
//    func setHeightMode(to mode: HeightMode) {
//        self.heightMode = mode
//    }
//}
