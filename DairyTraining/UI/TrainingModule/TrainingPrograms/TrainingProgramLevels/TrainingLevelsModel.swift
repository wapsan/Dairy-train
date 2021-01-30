import Foundation

protocol TrainingProgramsLevelsModelProtocl {
   
}

protocol TrainingProgramsLevelsModelOutput: AnyObject {
   
}

final class TrainingLevelsModel {
    
    enum Level: String, CaseIterable {
        case beginner = "Beginner"
        case amateur = "Amateur"
        case pro = "Professional"
        
        private var languageCode: String {
            return Locale.current.languageCode ?? "en"
        }
        
        var documentID: String {
            switch self {
            case .beginner:
                return "beginner"
            case .amateur:
                return "amateur"
            case .pro:
                return "pro"
            }
        }
        
        var title: String {
            return self.rawValue
        }
        
        var description: String {
            switch self {
            case .beginner:
                return "Beginner description"
            case .amateur:
                return "Amateur description"
            case .pro:
                return "Pro description"
            }
        }
    }
    
    
    
    weak var output: TrainingProgramsLevelsModelOutput?
}

// MARK: - TrainingProgramsLevelsModelProtocl
extension TrainingLevelsModel: TrainingProgramsLevelsModelProtocl {
    
}
