import Foundation

final class MuscleSubgropsViewModel {
    
    weak var view: MuscleSubgroupsViewPresenter?
    
    private(set) var subgroupList: [MuscleSubgroup.Subgroup]
    private(set) var groupTitle: String
    
    init(with subgroupList: [MuscleSubgroup.Subgroup], and groupTitle: String) {
        self.subgroupList = subgroupList
        self.groupTitle = groupTitle
    }
    
    func selectRow(at index: Int) {
        let selectSubgroup = self.subgroupList[index]
        let exerciseList = ExersiceModel(for: selectSubgroup).listOfExercices
        self.view?.pushExerciseList(with: exerciseList, and: selectSubgroup.name)
    }
}
