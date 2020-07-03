import Foundation

class AproachFirebase: NSObject, Codable {
    
//    //MARK: - CodingKeys
//    enum CodingKeys: String, CodingKey {
//        case weightMode
//        case number
//        case reps
//        case weight
//    }
//    
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

class ExerciceFirebase: NSObject, Codable {
    
    var name: String
    var id: Int
    var subgroupName: String
    var groupName: String
    var aproachlist: [AproachFirebase]
  
    init(with exerciceManagedobject: ExerciseManagedObject) {
        self.name = exerciceManagedobject.name
        self.id = Int(exerciceManagedobject.id)
        self.subgroupName = exerciceManagedobject.subgroupName
        self.groupName = exerciceManagedobject.groupName
        var inintAproachesArray: [AproachFirebase] = []
        for aproach in exerciceManagedobject.aproachesArray {
            inintAproachesArray.append(AproachFirebase(with: aproach))
        }
        self.aproachlist = inintAproachesArray
    }
}

class TrainingFirebase: NSObject, Codable {
    
    //MARK: - Properties
    var formatedDate: String?
     var exerciceArray: [ExerciceFirebase]
    
    //MARK: - Initialization
    init(with trainingManagedObject: TrainingManagedObject) {
        self.formatedDate = trainingManagedObject.formatedDate
        var initExercisesArray: [ExerciceFirebase] = []
        for exercise in trainingManagedObject.exercicesArray {
            initExercisesArray.append(ExerciceFirebase(with: exercise))
        }
        self.exerciceArray = initExercisesArray
    }
    
    //MARK: - Public methods
    func toJSONString() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            let localJSONString = String(data: data, encoding: .utf8)
            return localJSONString
        } catch  {
            return nil
        }
    }
}
