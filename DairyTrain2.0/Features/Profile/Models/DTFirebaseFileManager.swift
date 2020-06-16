import Foundation
import Firebase

class DTFirebaseFileManager {
    
    //MARK: - Singletone
    static let shared = DTFirebaseFileManager()
    
    //MARK: - Private properties
  //  private lazy var mainProfileInfo = ProfileInfoFileManager.shared
    private lazy var firebaseRef = Database.database().reference()
    private lazy var currentUser = Auth.auth().currentUser
    
    //MARK: - Public methods
    func updateMainUserInfoInFirebase() {
        guard let userUid = self.currentUser?.uid else { return }
        guard let userMainInfo = UserMainInfoModel(from: CoreDataManager.shared.readUserMainInfo()) else { return }
        let localJSONStringModel = userMainInfo.convertToJSONString()
        self.fetchMainUserInfo { (fireBaseJSONString) in
            guard let fireBaseJsonStringModel = fireBaseJSONString else { return }
            if fireBaseJsonStringModel != localJSONStringModel {
                self.firebaseRef.child("user").child(userUid).setValue(["userMainInfo": localJSONStringModel])
            }
        }
    }
    
    func updateMainUserInfoInDevice() {
        guard let userMainInfo = UserMainInfoModel(from: CoreDataManager.shared.readUserMainInfo()) else { return }
        let localJSONStringModel = userMainInfo.convertToJSONString()
        self.fetchMainUserInfo { (fireBaseJSONString) in
            guard let fireBaseJsonStringModel = fireBaseJSONString else { return }
            if fireBaseJsonStringModel != localJSONStringModel {
              guard let data = fireBaseJsonStringModel.data(using: .utf8) else { return }
              guard let mainInfo = try? JSONDecoder().decode(UserMainInfoModel.self, from: data) else { return }
                CoreDataManager.shared.updateUserMainInfo(to: mainInfo)
            }
        }

    }
    
    func fetchMainUserInfo(completion: @escaping ((String?) -> Void)) {
        guard let userUid = self.currentUser?.uid else { return }
        self.firebaseRef.child("user").child(userUid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaryValue = snapshot.value as? NSDictionary else { return }
            guard let jsonEncodedObject = try? JSONSerialization.data(withJSONObject: dictionaryValue,
                                                                      options: .prettyPrinted) else { return }
            guard let jsonString = String(data: jsonEncodedObject, encoding: .utf8) else { return }
            completion(jsonString)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
