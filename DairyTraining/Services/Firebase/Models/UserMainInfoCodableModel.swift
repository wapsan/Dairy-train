import Foundation

/**
Class created to fetch data model from UserMainInfoManagedObject for make encoding to JSON file.
*/
struct UserMainInfoCodableModel: Mapable {
        
    //MARK: - Model Keys
    private struct Key {
        static let age = "age"
        static let weight = "weight"
        static let height = "height"
        static let activityLevel = "activityLevel"
        static let gender = "gender"
        static let heightMode = "heightMode"
        static let weightMode = "weightMode"
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
    
    func mapToDictionary() -> [String: Any] {
        var userDictionary: [String: Any] = [:]
        userDictionary[Key.age] = self.age
        userDictionary[Key.weight] = self.weight
        userDictionary[Key.height] = self.height
        userDictionary[Key.activityLevel] = self.activityLevel?.rawValue
        userDictionary[Key.gender] = self.gender?.rawValue
        userDictionary[Key.heightMode] = self.heightMode?.rawValue
        userDictionary[Key.weightMode] = self.weightMode?.rawValue
        return userDictionary
    }
    
    init?(from dictionary: [String: Any]) {
        self.age = dictionary[Key.age] as? Int
        self.weight = dictionary[Key.weight] as? Float
        self.height = dictionary[Key.weight] as? Float
        self.gender = Gender.init(rawValue: dictionary[Key.gender] as? String ?? "_" )
        self.activityLevel = ActivityLevel.init(rawValue: dictionary[Key.activityLevel] as? String ?? "_")
        self.heightMode = MeteringSetting.HeightMode.init(rawValue: dictionary[Key.heightMode] as? String ?? "_")
        self.weightMode = MeteringSetting.WeightMode.init(rawValue: dictionary[Key.weightMode] as? String ?? "_")
    }
    
    //MARK: - Properties
    var age: Int?
    var weight: Float?
    var height: Float?
    var gender: Gender?
    var dateOfLastUpdate: String?
    var activityLevel: ActivityLevel?
    var heightMode: MeteringSetting.HeightMode?
    var weightMode: MeteringSetting.WeightMode?
    
    //MARK: - Initialization
    init?(from mainInfoManagedObject: MainInfoManagedObject?) {
        guard let mainInfoManagedObject = mainInfoManagedObject else { return nil }
        self.age = Int(mainInfoManagedObject.age)
        self.weight = mainInfoManagedObject.weight
        self.height = mainInfoManagedObject.height
        if let gender = mainInfoManagedObject.gender {
            self.gender = Gender.init(rawValue: gender) ?? Gender.notSet
        } else {
            self.gender = .none
        }
        if let activityLevel = mainInfoManagedObject.activitylevel {
            self.activityLevel = ActivityLevel.init(rawValue: activityLevel) ?? ActivityLevel.notSet
        } else {
            self.activityLevel = .none
        }
        if let weightMode = mainInfoManagedObject.weightMode {
            self.weightMode = MeteringSetting.WeightMode.init(rawValue: weightMode)
        }
        if let heightMode = mainInfoManagedObject.heightMode {
            self.heightMode = MeteringSetting.HeightMode.init(rawValue: heightMode)
        }
    }
}
