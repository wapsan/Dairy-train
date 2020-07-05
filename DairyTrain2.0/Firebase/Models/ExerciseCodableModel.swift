import Foundation

class ExerciseCodableModel: NSObject, Codable {
    
    //MARK: - Properties
    var name: String
    var id: Int
    var subgroupName: String
    var groupName: String
    var aproachlist: [AproachCodableModel]
    
    //MARK: - Initialization
    init(with exerciceManagedobject: ExerciseManagedObject) {
        self.name = exerciceManagedobject.name
        self.id = Int(exerciceManagedobject.id)
        self.subgroupName = exerciceManagedobject.subgroupName
        self.groupName = exerciceManagedobject.groupName
        var inintAproachesArray: [AproachCodableModel] = []
        for aproach in exerciceManagedobject.aproachesArray {
            inintAproachesArray.append(AproachCodableModel(with: aproach))
        }
        self.aproachlist = inintAproachesArray
    }
}
