import Foundation

final class MuscleGroupsViewModel {
    
    var muscleGroups: [MuscleGroup.Group]
    var router: MuscleGroupRouterProtocol?
    
    init(muscleGroups: [MuscleGroup.Group] = MuscleGroup().groups) {
        self.muscleGroups = muscleGroups
    }
    
    func getChoosenMuscularGroup(by index: Int) -> MuscleGroup.Group {
        return self.muscleGroups[index]
    }
    
    func selectRow(at index: Int, with trainingEntityTarget: TrainingEntityTarget) {
        let selectedGroup = self.muscleGroups[index]
        router?.showExerciseListViewController(for: selectedGroup, and: trainingEntityTarget)
    }
    
    func closeButtonPressed() {
        router?.closeExerciseFlow()
    }
}
