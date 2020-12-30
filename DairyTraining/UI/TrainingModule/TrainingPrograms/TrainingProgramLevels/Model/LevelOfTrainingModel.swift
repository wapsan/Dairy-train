import Foundation

enum LevelOfTrainingModel: String, CaseIterable {
    case beginner = "Beginner"
    case amateur = "Amateur"
    case pro = "Professional"
    
    private var languageCode: String {
        return Locale.current.languageCode ?? "en"
    }
    
    var id: String {
        switch self {
        case .beginner:
            return "beginner_" + languageCode
        case .amateur:
            return "amateur_" + languageCode
        case .pro:
            return "pro_" + languageCode
        }
    }
    
    var title: String {
        return self.rawValue
    }
}
