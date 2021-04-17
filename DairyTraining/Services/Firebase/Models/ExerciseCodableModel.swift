import Foundation

struct ExerciseCodableModel: Mapable {
    
    //MARK: - Properties
    var date: Date
    var name: String
    var id: Int
    var isDone: Bool?
    var subgroupName: String
    var groupName: String
    var aproachlist: [Approach]
    
    //MARK: - Initialization
    init(with exerciceManagedobject: ExerciseMO) {
        self.date = exerciceManagedobject.date ?? Date()
        self.isDone = exerciceManagedobject.isDone
        self.name = exerciceManagedobject.name
        self.id = Int(exerciceManagedobject.id)
        self.subgroupName = exerciceManagedobject.subgroupName
        self.groupName = exerciceManagedobject.groupName
        var inintAproachesArray: [Approach] = []
        for aproach in exerciceManagedobject.aproachesArray {
            inintAproachesArray.append(Approach(with: aproach))
        }
        self.aproachlist = inintAproachesArray
    }
}
