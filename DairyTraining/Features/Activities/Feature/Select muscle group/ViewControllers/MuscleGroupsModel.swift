import Foundation


class MuscleGroupModel {
    
    private(set) var muscleGroupList: [MuscleGroup.Group]
    
    init(muscleGroups: [MuscleGroup.Group] = MuscleGroup().groups) {
        self.muscleGroupList = muscleGroups
    }
    
    
}
