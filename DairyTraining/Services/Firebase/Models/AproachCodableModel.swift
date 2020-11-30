import Foundation

struct AproachCodableModel: Codable {

    //MARK: - Properties
    var weightMode: String
    var number: Int
    var reps: Int
    var weight: Float
    
    //MARK: - Initialization
    init(with aproachManagedObject: AproachManagedObject) {
        self.weightMode = aproachManagedObject.weightMode
        self.number = Int(aproachManagedObject.number)
        self.reps = Int(aproachManagedObject.reps)
        self.weight = aproachManagedObject.weight
    }
}
