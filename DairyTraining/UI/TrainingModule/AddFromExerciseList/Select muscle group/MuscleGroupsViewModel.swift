import Foundation

final class MuscleGroupsViewModel {
    
    var muscleGroups: [MuscleGroup.Group]
    
    init(muscleGroups: [MuscleGroup.Group] = MuscleGroup().groups) {
        self.muscleGroups = muscleGroups
    }
    
    func getChoosenMuscularGroup(by index: Int) -> MuscleGroup.Group {
        return self.muscleGroups[index]
    }
    
    func selectRow(at index: Int, with trainingEntityTarget: TrainingEntityTarget) {
        let selectedGroup = self.muscleGroups[index]
        MainCoordinator.shared.coordinateChild(
            to: MuscleGroupsCoordinator.Target.new(muscularGroup: selectedGroup,
                                                   trainingEntityTarget: trainingEntityTarget))
//        MainCoordinator.shared.coordinateChild(to: MuscleGroupsCoordinator.Target.muscularSubgroups(patern: trainingEntityTarget, muscleGroup: selectedGroup))
    }
}
