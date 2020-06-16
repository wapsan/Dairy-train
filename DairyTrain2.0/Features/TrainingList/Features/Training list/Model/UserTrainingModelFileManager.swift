import Foundation

class UserTrainingModelFileManager {
    
    //MARK: - Singletone propertie
    static let shared = UserTrainingModelFileManager()
    
    //MARK: - Private properties
    private var directoryURL: URL
    private lazy var strinPath = "userTrainingInfo"
    private var _userTrainingInfo: UserTrainingModel?
    
    //MARK: - Properties
    var trainingInfo: UserTrainingModel {
        //TODO: - fetch training model
        self.readData()
        guard let userTrainingInfo = self._userTrainingInfo else { return UserTrainingModel() }
        return userTrainingInfo
    }
    
    //MARK: - Initialization
    init() {
        self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //MARK: - Private methods
   func writeData() {
        let localPath = self.directoryURL.appendingPathComponent(self.strinPath) as URL?
        if let filePath = localPath, let model = self._userTrainingInfo,
            let encodeData = try? JSONEncoder().encode(model) {
            do {
                try encodeData.write(to: filePath)
                print("Training data write.")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func readData() {
        let localPath = self.directoryURL.appendingPathComponent(self.strinPath) as URL?
        if let filePath = localPath,
            let data = FileManager.default.contents(atPath: filePath.path),
            let trainingInfo = try? JSONDecoder().decode(UserTrainingModel.self, from: data) {
            self._userTrainingInfo = trainingInfo
            print("Training data read.")
        } else {
            self._userTrainingInfo = UserTrainingModel()
        }
    }
    
    //MARK: - Private methods
    func removeTrainingDataFromDevice() {
           let localPath = self.directoryURL.appendingPathComponent(self.strinPath) as URL?
           if let filePath = localPath {
               do {
                   try FileManager.default.removeItem(at: filePath)
                   print("Data successfully removed from device.")
               } catch  {
                   print(error.localizedDescription)
               }
           }
       }
    
    func addExercesToTrain(_ exercices: [Exercise]) -> Bool {
        let newTraininig = Train(with: exercices)
        guard let trainingList = self._userTrainingInfo?.trainingList else { return true }
        guard !trainingList.isEmpty else {
            self.addTrain(newTraininig)
            return true }
        for train in trainingList {
            if newTraininig.dateTittle != train.dateTittle {
                self.addTrain(newTraininig)
                return true
            } else {
                train.addExercises(exercices)
                self.writeData()
                return false
            }
        }
        return false
    }
    
    func addTrain(_ train: Train) {
        self._userTrainingInfo?.trainingList.append(train)
        self.writeData()
    }
    
    
}
