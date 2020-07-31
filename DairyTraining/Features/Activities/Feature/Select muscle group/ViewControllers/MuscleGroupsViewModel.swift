import Foundation

protocol MuscleGroupsViewModelInput {
    func selectRow(at index: Int)
    
}

class MuscleGroupsViewModel {
    
    weak var viewPresenter: MuscleGroupsViewPresenter!
    
    var muscleGroups: [MuscleGroup.Group]
   
    init(muscleGroups: [MuscleGroup.Group] = MuscleGroup().groups) {
        self.muscleGroups = muscleGroups
    }
    
    func getChoosenMuscularGroup(by index: Int) -> MuscleGroup.Group {
        return self.muscleGroups[index]
    }
}

//MARK: - MuscleGroupsViewModelInput
extension MuscleGroupsViewModel: MuscleGroupsViewModelInput {
    
    func selectRow(at index: Int) {
           let selectedGroup = self.muscleGroups[index]
           let subGroupList = MuscleSubgroup(for: selectedGroup).listOfSubgroups
           self.viewPresenter.pushSubgroupsViewController(with: subGroupList, and: selectedGroup)
       }
}
