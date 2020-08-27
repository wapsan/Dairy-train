import Foundation

final class MuscleSubgropsViewModel {
    
    private(set) var subgroupList: [MuscleSubgroup.Subgroup]
    private(set) var groupTitle: String
    
    init(with subgroupList: [MuscleSubgroup.Subgroup], and groupTitle: String) {
        self.subgroupList = subgroupList
        self.groupTitle = groupTitle
    }
}
