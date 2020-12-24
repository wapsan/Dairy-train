import Foundation
import Firebase

final class FirebaseDataManager {
    
    //MARK: - Singletone
    static let shared = FirebaseDataManager()
    
    //MARK: - Private properties
    private lazy var firebaseRef = Database.database().reference()
    private lazy var _lastUpdatedDate: String = ""
    private lazy var notUpdatedDate = "Date is not updated."
    
    private lazy var userMainInfoKey = "user_info"
    private lazy var userTrainInfoKey = "user_training_list"
    private lazy var userTraininigPaternsInfoKey = "user_trainin_paterns"
    private lazy var userKeyPath = "users"
    private lazy var updateDateKeyPatth = "last_update"
    
    private lazy var dispatchGroup = DispatchGroup()
    
    private var currentDateWithUpdatingFromat: String {
        return DateHelper.shared.getFormatedDateFrom(Date(), with: .synhronizationDateFromat)
    }
    
    //MARK: - Initialization
    private init () { }
    
    //MARK: - Publick methods
    private  func upDateDateOfLastUpdate() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .child(self.updateDateKeyPatth)
            .setValue(self.currentDateWithUpdatingFromat) { [weak self] _,_  in
                self?.dispatchGroup.leave()
            }
    }
    
    func synhronizeDataToServer(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        self.synhronizeMainUserInfoToServer()
        dispatchGroup.enter()
        self.synhronizeTrainingUserInfoToServer()
        dispatchGroup.enter()
        self.upDateDateOfLastUpdate()
        dispatchGroup.enter()
        self.sunhronizeTrainingPaternsToServer()
        dispatchGroup.notify(queue: .main, execute: completion)
    }
    
    func fetchDataFromFirebase(completion: @escaping (_ data: Result<FrebaseServerModel, Error>) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        var traingArray: [TrainingCodableModel] = []
        var trainingPaterns: [TrainingPaternCodableModel] = []
        var mainInfo: UserMainInfoCodableModel?
        var dateOfUpdate: String?
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                guard let dictionaryValue = snapshot.value as? NSDictionary else {
                    return
                }
                if let mainInfoDictionary = dictionaryValue[self.userMainInfoKey] as? [String: Any] {
                    mainInfo = UserMainInfoCodableModel(from: mainInfoDictionary)
                }
                dateOfUpdate = dictionaryValue[self.updateDateKeyPatth] as? String
                if let trainingInfoDictionary = dictionaryValue[self.userTrainInfoKey] as? [String: String] {
                    for element in trainingInfoDictionary {
                        if let trainingData = element.value.data(using: .utf8),
                            let train = try? JSONDecoder().decode(TrainingCodableModel.self,
                                                                  from: trainingData) {
                            traingArray.append(train)
                        }
                    }
                }
                if let trainingInfoDictionary = dictionaryValue[self.userTraininigPaternsInfoKey] as? [String: String] {
                    for element in trainingInfoDictionary {
                        if let trainingData = element.value.data(using: .utf8),
                            let train = try? JSONDecoder().decode(TrainingPaternCodableModel.self,
                                                                  from: trainingData) {
                            trainingPaterns.append(train)
                        }
                    }
                }
                let fireBaseServerModel = FrebaseServerModel(dateOfUpdate: dateOfUpdate,
                                                             userMainInfoModel: mainInfo,
                                                             trainingLis: traingArray,
                                                             trainingPaternList: trainingPaterns)
                completion(.success(fireBaseServerModel))
            }
    }
    
    //MARK: - Private methods
    private func synhronizeMainUserInfoToServer() {
        guard let userUid = Auth.auth().currentUser?.uid,
            let userMainInfo = UserMainInfoCodableModel(from: UserDataManager.shared.readUserMainInfo()) else { return }
        let userMainInfoJSON = userMainInfo.mapToDictionary()
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .child(self.userMainInfoKey)
            .setValue(userMainInfoJSON) { [weak self] (error, data) in
                self?.dispatchGroup.leave()
            }
    }
    
    private func synhronizeTrainingUserInfoToServer() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let trainingListFromLocalBase = TrainingDataManager.shared.getTraingList()
        var trainingInfoDictionary: [String: Any] = [:]
        trainingListFromLocalBase.enumerated().forEach( {(index, train) in
            let trainingData = TrainingCodableModel(with: train)
            guard let trainingInfoJSON = trainingData.mapToJSON() else { return }
            trainingInfoDictionary["train_\(index + 1)"] = trainingInfoJSON
        })
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .child(self.userTrainInfoKey)
            .setValue(trainingInfoDictionary) { [weak self] (error, data) in
                self?.dispatchGroup.leave()
            }
    }
    
    private func sunhronizeTrainingPaternsToServer() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let localTrainingPaterns = TrainingDataManager.shared.trainingPaterns
        var parameters: [String: String] = [:]
        localTrainingPaterns.enumerated().forEach({
            let patern = TrainingPaternCodableModel(for: $1)
            guard let paternJSON = patern.mapToJSON() else { return }
            parameters["patern_\($0 + 1)"] = paternJSON
        })
        self.firebaseRef
            .child(userKeyPath)
            .child(userUID)
            .child(userTraininigPaternsInfoKey)
            .setValue(parameters) { [weak self] (error, data) in
                self?.dispatchGroup.leave()
            }
    }
}
