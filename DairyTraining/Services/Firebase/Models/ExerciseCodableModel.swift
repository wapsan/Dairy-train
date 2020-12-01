import Foundation

struct ExerciseCodableModel: Mapable {
    
    //MARK: - Properties
    var date: Date
    var name: String
    var id: Int
    var subgroupName: String
    var groupName: String
    var aproachlist: [AproachCodableModel]
    
    //MARK: - Initialization
    init(with exerciceManagedobject: ExerciseManagedObject) {
        self.date = exerciceManagedobject.date ?? Date()
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
