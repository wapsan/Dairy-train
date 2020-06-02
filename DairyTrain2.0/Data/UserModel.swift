import UIKit

class UserModel {
    
    static var shared = UserModel()
    
    var userID: String?
    
    var gender: String?
    var levelOfActivity: String?
    
    var age: Int?
    var height: Double?
    var weight: Double?
    
    var trains: [Train] = []
    
    //MARK: - Publick methods
    func addTrain(_ train: Train) {
        self.trains.append(train)
    }
    
    func removeTrain(at index: Int) {
        self.trains.remove(at: index)
    }
    
//    func addTrain(with date: String, and exercices: [Exercise]) {
//        for train in self.trains {
//            if train.dateTittle! != DateHelper.shared.currnetDate {
//                self.addTrain(Train(with: exercices))
//            } else {
//                train.addExercises(exercices)
//            }
//        }
//    }
    
    func createTrain(with exercices: [Exercise]) {
        let createdTrain = Train(with: exercices)
        guard !self.trains.isEmpty else { self.addTrain(createdTrain); return}
        for train in self.trains {
            if createdTrain.dateTittle != train.dateTittle {
                self.addTrain(createdTrain)
            } else {
                train.addExercises(exercices)
            }
        }
    }
    
}
