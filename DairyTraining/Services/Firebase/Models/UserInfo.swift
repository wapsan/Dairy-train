import Foundation

/**
Class created to fetch data model from UserMainInfoManagedObject for make encoding to JSON file.
*/
struct UserInfo: Mapable {
        
    //MARK: - Model Keys
    private struct Key {
        static let age = "age"
        static let weight = "weight"
        static let height = "height"
        static let activityLevel = "activityLevel"
        static let gender = "gender"
        static let heightMode = "heightMode"
        static let weightMode = "weightMode"
        static let nutritionMode = "nutritionMode"
    }
    
    //MARK: - Enums
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case notSet = "_"
    }
    
    enum ActivityLevel: String, Codable {
        case low = "Low"
        case mid = "Mid"
        case high = "High"
        case notSet = "_"
    }
    
    enum NutritionMode: String, Codable {
        case loseWeight = "loseWeight"
        case balanceWeight = "balanceWeight"
        case weightGain = "weightGain"
        case custom = "custom"
        
        static var defaultNutritioonMode: NutritionMode {
            return .balanceWeight
        }
        
        var presentationTitle: String {
            return "Meal plane: " + rawValue
        }
    }
    
    enum WeightMode: String, Codable, CaseIterable {
        case kg = "Kg."
        case lbs = "Lbs."
        
        var multiplier: Float {
            switch self {
            case .kg:
                return kgMultiplier
            case .lbs:
                return lbsMultiplier
            }
        }
        
        static var defaultWeightMode: WeightMode {
            return .lbs
        }
        
        var description: String {
            switch self {
            
            case .kg:
                return "kg."
            case .lbs:
                return "lbs."
            }
        }
        
        private var kgMultiplier: Float  {
            return 1 * 2.2
        }
        
        private var lbsMultiplier: Float {
            return 1 / 2.2
        }
    }
    
    enum HeightMode: String, Codable, CaseIterable {
        case cm = "Cm."
        case ft = "Ft."
        
        var description: String {
            switch self {
            
            case .cm:
                return "cm."
            case .ft:
                return "ft."
            }
        }
        
        static var defaultHeightMode: HeightMode {
            return .ft
        }
        
        var multiplier: Float {
            switch self {
            case .cm:
                return cmMultiplier
            case .ft:
                return ftMultiplier
            }
        }
        
        private var cmMultiplier: Float {
            return 1 * 0.032
        }
        
        private var ftMultiplier: Float {
            return 1 / 0.032
        }
    }
    
    func mapToDictionary() -> [String: Any] {
        var userDictionary: [String: Any] = [:]
        userDictionary[Key.age] = age
        userDictionary[Key.weight] = weightValue
        userDictionary[Key.height] = heightValue
        userDictionary[Key.activityLevel] = activityLevel
        userDictionary[Key.gender] = gender
        userDictionary[Key.heightMode] = heightMode
        userDictionary[Key.weightMode] = weightMode
        userDictionary[Key.nutritionMode] = nutritionMode
        return userDictionary
    }
    
    //MARK: - Properties
    var age: Int?
    var weightValue: Float?
    var heightValue: Float?
    var gender: String?
    var dateOfLastUpdate: String?
    var activityLevel: String?
    var nutritionMode: String
    var heightMode: String
    var weightMode: String
    
    //MARK: - Initialization
    init(userInfoMO: UserInfoMO) {
        self.age = userInfoMO.age.int
        self.weightValue = userInfoMO.weightValue
        self.heightValue = userInfoMO.heightValue
        self.gender = userInfoMO.gender
        self.dateOfLastUpdate = userInfoMO.dateOfLastUpdate
        self.activityLevel = userInfoMO.activityLevel
        self.nutritionMode = userInfoMO.nutritionMode
        self.heightMode = userInfoMO.heightMode
        self.weightMode = userInfoMO.weightMode
    }
    
    init(from dictionary: [String: Any]) {
        self.age = dictionary[Key.age] as? Int
        self.gender = dictionary[Key.gender] as? String
        self.activityLevel = dictionary[Key.activityLevel] as? String
        self.nutritionMode = dictionary[Key.nutritionMode] as? String ?? NutritionMode.defaultNutritioonMode.rawValue
        self.heightMode = dictionary[Key.heightMode] as? String ?? HeightMode.defaultHeightMode.rawValue
        self.weightMode = dictionary[Key.weightMode] as? String ?? WeightMode.defaultWeightMode.rawValue
        self.weightValue = dictionary[Key.weight] as? Float ?? 0
        self.heightValue = dictionary[Key.height] as? Float ?? 0
    }
}
