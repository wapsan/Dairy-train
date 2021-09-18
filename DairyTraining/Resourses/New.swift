import Foundation
import UIKit

struct NewExercise: Codable {
    let name: String
    let muscularSubroup: MuscularSubgroup2
    let muscularGroup: MuscularGroup
}

enum MuscularGroup: String, CaseIterable, Codable {
    case shoulders
    case chest
    case arms
    case back
    case core
    case legs
    
    var image: UIImage? {
        switch self {
        case .shoulders:
            return UIImage.shouldersImage
        case .chest:
            return UIImage.chestImage
        case .arms:
            return UIImage.armsImage
        case .back:
            return UIImage.backImage
        case .core:
            return UIImage.coreImage
        case .legs:
            return UIImage.legsImage
        }
    }
    
    var name: String {
        rawValue
    }
    
    var subgroups: [MuscularSubgroup2] {
        switch self {
        case .shoulders:
            return [.frontDelts,
                    .middleDelts,
                    .rearDelts]
            
        case .chest:
            return [.upperChest,
                    .middleChest,
                    .lowerChest]
            
        case .arms:
            return [.biceps,
                    .triceps]
            
        case .back:
            return [.latissimusDorsi,
                    .trapezoid]
            
        case .core:
            return [.abs,
                    .lowBack]
            
        case .legs:
            return [.frontSideHip,
                    .backSideHip,
                    .calves]
            
        }
    }
}


struct ExerciseLoader {
    
    static private let jsonExtension = "json"
    
    static func loadExercise(for muscularSubgroups: MuscularSubgroup2) -> [NewExercise] {
        
        guard let fileURL = Bundle.main.url(forResource: muscularSubgroups.path,
                                            withExtension: ExerciseLoader.jsonExtension) else {
            return []
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        
        guard let exercises = try? JSONDecoder().decode([NewExercise].self, from: data) else {
            return []
        }

        return exercises
    }
}




extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
