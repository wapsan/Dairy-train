import Foundation

struct TrainingCodableModel: Mapable {
    
    //MARK: - Properties
    var formatedDate: String?
    var exerciceArray: [ExerciseCodableModel]
    var date: Date
    
    //MARK: - Initialization
    init(with trainingManagedObject: WorkoutMO) {
        self.formatedDate = trainingManagedObject.formatedDate
        self.date = trainingManagedObject.date
        var initExercisesArray: [ExerciseCodableModel] = []
        for exercise in trainingManagedObject.exercicesArray {
            initExercisesArray.append(ExerciseCodableModel(with: exercise))
        }
        self.exerciceArray = initExercisesArray
    }
}
