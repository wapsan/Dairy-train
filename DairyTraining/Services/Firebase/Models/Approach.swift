import Foundation

struct Approach: Mapable {

    //MARK: - Properties
    var weightMode: String
    var index: Int
    var reps: Int
    var weight: Float

    //MARK: - Initialization
    init(with aproachManagedObject: ApproachMO) {
        self.weightMode = aproachManagedObject.weightMode
        self.index = Int(aproachManagedObject.index)
        self.reps = Int(aproachManagedObject.reps)
        self.weight = aproachManagedObject.weightValue
    }
    
    init(index: Int,
         reps: Int,
         weight: Float,
         weightMode: UserInfo.WeightMode = UserDefaults.standard.weightMode) {
        
        self.index = index
        self.reps = reps
        self.weight = weight
        self.weightMode = weightMode.rawValue
    }
}
