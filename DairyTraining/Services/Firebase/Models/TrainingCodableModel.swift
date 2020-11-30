import Foundation

struct TrainingCodableModel: Codable {
    
    //MARK: - Properties
    var formatedDate: String?
    var exerciceArray: [ExerciseCodableModel]
    var date: Date
    
    //MARK: - Initialization
    init(with trainingManagedObject: TrainingManagedObject) {
        self.formatedDate = trainingManagedObject.formatedDate
        self.date = trainingManagedObject.date
        var initExercisesArray: [ExerciseCodableModel] = []
        for exercise in trainingManagedObject.exercicesArray {
            initExercisesArray.append(ExerciseCodableModel(with: exercise))
        }
        self.exerciceArray = initExercisesArray
    }
    
    //MARK: - Public methods
    func toJSONString() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            let localJSONString = String(data: data, encoding: .utf8)
            return localJSONString
        } catch {
            return nil
        }
    }
}
