import Foundation

class CurrentTrainingModel: NSObject, Codable {
    
    //MARK: - Private properties
    private var exercicesSet = Set<String>()

    //MARK: - Properties
    var exercises: [Exercise] = []
    var dateTittle: String
    
    var subgroupInCurrentTrain: [MuscleSubgroup.Subgroup] {
        var subgroups: [MuscleSubgroup.Subgroup] = []
        var subgroupsSet = Set<MuscleSubgroup.Subgroup>()
        for exercice in self.exercises {
            let subgroup = exercice.subgroub
            if subgroupsSet.insert(subgroup).inserted {
                subgroups.append(subgroup)
            }
        }
        return subgroups
    }
    var groupsInCurrentTrain: [MuscleGroup.Group] {
        var groups: [MuscleGroup.Group] = []
        var gropSet = Set<MuscleGroup.Group>()
        for exercise in self.exercises {
            let group = exercise.group
            if gropSet.insert(group).inserted {
                groups.append(group)
            }
        }
        return groups
    }
}
