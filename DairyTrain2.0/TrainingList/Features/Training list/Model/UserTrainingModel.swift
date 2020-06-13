import Foundation

class UserTrainingModel: NSObject, Codable {
    
    //MARK: - Properties
    var trainingList: [Train]  = []
    var trainCount: Int {
        return self.trainingList.count
    }
}
