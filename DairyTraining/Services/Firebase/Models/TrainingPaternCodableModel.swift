import Foundation

struct TrainingPaternCodableModel: Mapable {
    
    // MARK: - Properties
    var name: String
    var date: Date
    var exerciseArray: [ExerciseCodableModel]
    
    // MARK: - Initialization
    init(for trainingPaternManagedObject: WorkoutTemplateMO) {
        self.date = trainingPaternManagedObject.date
        self.name = trainingPaternManagedObject.name
        self.exerciseArray = trainingPaternManagedObject.exerciseArray.map({ ExerciseCodableModel(with: $0) })
    }
}
