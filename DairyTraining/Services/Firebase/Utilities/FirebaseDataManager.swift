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
    private lazy var nutritionDataInfoKey = "user_nutrition_data"
    private lazy var customNutritionModeDataInfoKey = "custom_nutrition_mode"
    private lazy var historyNutritionData = "history_nutrition_data"
    
    private lazy var dispatchGroup = DispatchGroup()
    
    private var currentDateWithUpdatingFromat: String {
        return DateHelper.shared.getFormatedDateFrom(Date(), with: .synhronizationDateFromat)
    }
    
    private let persistenceService: PersistenceServiceProtocol
    
    
    //MARK: - Initialization
    private init () {
        self.persistenceService = PersistenceService()
    }
    
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
        synhronizeMainUserInfoToServer()
        dispatchGroup.enter()
        synhronizeTrainingUserInfoToServer()
        dispatchGroup.enter()
        upDateDateOfLastUpdate()
        dispatchGroup.enter()
        sunhronizeTrainingPaternsToServer()
        dispatchGroup.enter()
        synhronizeNutritionDataToServer()
        dispatchGroup.enter()
        synchronizeCustomnutritionToServer()
        dispatchGroup.notify(queue: .main, execute: completion)
    }
    
    func fetchDataFromFirebase(completion: @escaping (_ data: Result<FrebaseServerModel, SearchFoodAPI.NetWorkError>) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        var traingArray: [TrainingCodableModel] = []
        var trainingPaterns: [TrainingPaternCodableModel] = []
        var mainInfo: UserInfo?
        var dateOfUpdate: String?
        var customnutritionData: CustomNutritionCodableModel?
        var daynutritonData: [DayNutritionCodableModel] = []
        self.firebaseRef
            .child(self.userKeyPath)
            .child(userUid)
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                guard let dictionaryValue = snapshot.value as? NSDictionary else {
                    completion(.failure(.noResponse))
                    return
                }
                if let mainInfoDictionary = dictionaryValue[self.userMainInfoKey] as? [String: Any] {
                    mainInfo = UserInfo(from: mainInfoDictionary)
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
                if let nutritionData = dictionaryValue[self.nutritionDataInfoKey] as? [String: Any] {
                    if let dict = nutritionData[self.customNutritionModeDataInfoKey] as? [String: Any] {
                        customnutritionData = CustomNutritionCodableModel(from: dict)
                    }
                    if let dict = nutritionData[self.historyNutritionData] as? [String: String] {
                        for elemnt in dict {
                            if let data = elemnt.value.data(using: .utf8),
                               let nutritionData = try? JSONDecoder().decode(DayNutritionCodableModel.self, from: data) {
                                daynutritonData.append(nutritionData)
                            }
                        }
                    }
                }
                
                
                let fireBaseServerModel = FrebaseServerModel(dateOfUpdate: dateOfUpdate,
                                                             userMainInfoModel: mainInfo,
                                                             trainingLis: traingArray,
                                                             trainingPaternList: trainingPaterns,
                                                             customNutritonData: customnutritionData,
                                                             dayNutritionCodableModel: daynutritonData)
                completion(.success(fireBaseServerModel))
            }
    }
    
    //MARK: - Private methods
    private func synhronizeMainUserInfoToServer() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let userMainInfo = UserInfo(userInfoMO: persistenceService.user.userInfo)
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
        let trainingListFromLocalBase = persistenceService.workout.fetchWorkouts(for: .allTime)
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
        let localTrainingPaterns = persistenceService.workoutTemplates.getWorkoutsTemplates()
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
    
    private func synhronizeNutritionDataToServer() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let localNutritionData = persistenceService.nutrition.fetchAllNutritionData()
        var parameteres: [String: String] = [:]
        localNutritionData.enumerated().forEach({
            let historyData = DayNutritionCodableModel(from: $1)
            guard let paternJSON = historyData.mapToJSON() else { return }
            parameteres["day_\($0 + 1)"] = paternJSON
        })
        firebaseRef
            .child(userKeyPath)
            .child(userUID)
            .child(nutritionDataInfoKey)
            .child(historyNutritionData)
            .setValue(parameteres) { [weak self] (error, data) in
                self?.dispatchGroup.leave()
            }
    }
    
    private func synchronizeCustomnutritionToServer() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let localNutritionData = persistenceService.nutrition.customNutritionMode
        let a = CustomNutritionCodableModel(from: localNutritionData)
        let parameteres: [String: Any] = a.toDictionary()
        firebaseRef
            .child(userKeyPath)
            .child(userUID)
            .child(nutritionDataInfoKey)
            .child(customNutritionModeDataInfoKey)
            .setValue(parameteres) { [weak self] (error, data) in
                self?.dispatchGroup.leave()
            }
    }
}
