import Foundation

struct TrainingPaternCodableModel: Mapable {
    
    // MARK: - Properties
    var name: String
    var exerciseArray: [ExerciseCodableModel]
    
    // MARK: - Initialization
    init(for trainingPaternManagedObject: TrainingPaternManagedObject) {
        self.name = trainingPaternManagedObject.name
        self.exerciseArray = trainingPaternManagedObject.exerciseArray.map({ ExerciseCodableModel(with: $0) })
    }
}
