import UIKit

class UserModel {
    
    enum Gender: String {
        case male = "Male"
        case female = "Female"
        
        var title: String {
            switch self {
            case .male:
                return self.rawValue
            case .female:
                return self.rawValue
            }
        }
    }
    
    enum ActivivtyLevel: String {
        case low = "Low"
        case mid = "Mid"
        case high = "High"
        
        var title: String {
            switch self {
            case .low:
                return self.rawValue
            case .mid:
                return self.rawValue
            case .high:
                return self.rawValue
            }
        }
    }
    
    //MARK: - Singletone properties
    static var shared = UserModel()
    
    //MARK: - Private properties
    private var age: Int?
    private var weight: Double?
    private var height: Double?
    private var trainCount: Int? = 0
    private var gender: UserModel.Gender?
    private var activityLevel: UserModel.ActivivtyLevel?
    
    var userID: String?
    
    var heightMode: MeteringSetting.HeightMode
    var weightmode: MeteringSetting.WeightMode
    
    init() {
        self.heightMode = MeteringSetting.shared.heightMode
        self.weightmode = MeteringSetting.shared.weightMode
    }
    
    func setUserHeightMode(to mode: MeteringSetting.HeightMode) {
        self.heightMode = mode
    }
    
    //MARK: - Properties
    var displayAge: String {
        return String(self.age ?? 0)
    }
    
    var displayHeight: String {
        return String(self.height ?? 0)
    }
    
    var displayWeight: String {
        return String(self.weight ?? 0)
    }
    
    var displayTrainCount: String {
        return String(self.trainCount ?? 0)
    }
    
    var displayGender: String {
        guard let gender = self.gender else { return "_" }
        return gender.title
    }
    
    var displayActivityLevel: String {
        guard let activivtyLevel = self.activityLevel else { return "_" }
        return activivtyLevel.title
    }
    
    var trains: [Train] = []
    
    //MARK: - Publick methods
    func setAge(to age: Int) {
        self.age = age
    }
    
    func setHeight(to height: Double) {
        self.height = height
    }
    
    func getHeight() -> Double {
        return self.height ?? 0
    }
    
    func setWeight(to weight: Double) {
        self.weight = weight
    }
    
    func setGender(to gender: UserModel.Gender) {
        self.gender = gender
    }
    
    func setActivivtyLevel(to activivtyLevel: UserModel.ActivivtyLevel) {
        self.activityLevel = activivtyLevel
    }
    
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
        self.trainCount = self.trains.count
    }
    
}
