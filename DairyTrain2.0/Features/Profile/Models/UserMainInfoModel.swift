import Foundation

/**
Class created to fetch data model from UserMainInfoManagedObject for make encoding to JSON file.
*/
class UserMainInfoModel: NSObject, Codable {
        
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
    
    //MARK: - Properties
    var age: Int?
    var weight: Float?
    var height: Float?
    var gender: Gender?
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
    
    //MARK: - Public methods
    func convertToJSONString() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            let localJSONString = String(data: data, encoding: .utf8)
            return localJSONString
        } catch {
            return nil
        }
    }
}
