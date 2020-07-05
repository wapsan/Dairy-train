import Foundation
import Firebase

class DTFirebaseFileManager {
    
    //MARK: - Singletone
    static let shared = DTFirebaseFileManager()
    
    //MARK: - Private properties
    private lazy var firebaseRef = Database.database().reference()
    private lazy var _lastUpdatedDate: String = ""
    private lazy var notUpdatedDate = "Date is not updated."
    
    private lazy var userMainInfoKey = "userMainInfo"
    private lazy var userTrainInfoKey = "userTrainingList"
    private lazy var userKeyPath = "user"
    
    //MARK: - Properties
    lazy var isDataUpdated: Bool = false
    var lastUpdatedDate: String {
        if !self.isDataUpdated {
            return self.notUpdatedDate
        } else {
            return self._lastUpdatedDate
        }
    }
    
    //MARK: - Initialization
    private init () { }
    
    //MARK: - Publick methods
    func synhronizeDataToServer(completion: @escaping () -> Void) {
        self.synhronizeMainUserInfoToServer()
        self.synhronizeTrainingUserInfoToServer()
        completion()
    }
    
    func synhronizeDataFromServer(completion: @escaping (_ mainInfo: UserMainInfoCodableModel?,
        _ trainingList: [TrainingCodableModel]) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        var traingArray: [TrainingCodableModel] = []
        var mainInfo: UserMainInfoCodableModel?
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .observeSingleEvent(of: .value) { (snapshot) in
                
                guard let dictionaryValue = snapshot.value as? NSDictionary else {
                    completion(nil, [])
                    return
                }
                
                if let mainInfoJSON = dictionaryValue[self.userMainInfoKey] as? String,
                    let mainInfoData = mainInfoJSON.data(using: .utf8) {
                    let mainInfo2 = try? JSONDecoder().decode(UserMainInfoCodableModel.self,
                                                              from: mainInfoData)
                    mainInfo = mainInfo2
                }
                
                if let trainingInfoDictionary = dictionaryValue[self.userTrainInfoKey] as? [String: String] {
                    for element in trainingInfoDictionary {
                        if let trainingData = element.value.data(using: .utf8),
                            let train = try? JSONDecoder().decode(TrainingCodableModel.self,
                                                                  from: trainingData) {
                            traingArray.append(train)
                        }
                    }
                }
                completion(mainInfo, traingArray)
        }
    }
    
    //MARK: - Private methods
    private func synhronizeMainUserInfoToServer() {
        guard let userUid = Auth.auth().currentUser?.uid,
            let userMainInfo = UserMainInfoCodableModel(from: CoreDataManager.shared.readUserMainInfo()) else { return }
        let userMainInfoJSON = userMainInfo.convertToJSONString()
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .child(self.userMainInfoKey)
            .setValue(userMainInfoJSON)
    }
    
    private func synhronizeTrainingUserInfoToServer() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let trainingListFromLocalBase = CoreDataManager.shared.fetchTrainingList()
        var trainingInfoDictionary: [String: String] = [:]
        trainingListFromLocalBase.enumerated().forEach( {(index, train) in
            let trainingData = TrainingCodableModel(with: train)
            guard let trainingInfoJSON = trainingData.toJSONString() else { return }
            trainingInfoDictionary["Train \(index + 1)"] = trainingInfoJSON
        })
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .child(self.userTrainInfoKey)
            .setValue(trainingInfoDictionary)
    }
}
