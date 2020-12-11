
import Foundation

enum TimeRangeModel: CaseIterable {
    case seconds30
    case seconds60
    case seconds90
    case seconds120
    
    var duration: CFTimeInterval {
        switch self {
        case .seconds30:
            return CFTimeInterval(30)
        case .seconds60:
            return CFTimeInterval(60)
        case .seconds90:
            return CFTimeInterval(90)
        case .seconds120:
            return CFTimeInterval(120)
        }
    }
}
