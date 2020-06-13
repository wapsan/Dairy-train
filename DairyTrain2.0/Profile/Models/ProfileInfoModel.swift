import Foundation

class ProfileInfoModel: NSObject, Codable {
        
    //MARK: - Codingkeys Enum
    enum CodingKeys: String, CodingKey {
        case gender
        case activityLevel
        case age
        case weight
        case height
    }
    
    //MARK: - Enums
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
    }
    
    enum ActivityLevel: String, Codable {
        case low = "Low"
        case mid = "Mid"
        case high = "High"
    }
   
    //MARK: - Properties
    var age: Int?
    var weight: Double?
    var height: Double?
    var gender: Gender?
    var activityLevel: ActivityLevel?
}
