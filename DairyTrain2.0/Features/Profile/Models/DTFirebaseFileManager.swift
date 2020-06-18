import Foundation
import Firebase

class DTFirebaseFileManager {
    
    //MARK: - Singletone
    static let shared = DTFirebaseFileManager()
    
    private init () {    }
    
    //MARK: - Private properties
    private lazy var firebaseRef = Database.database().reference()
    private var currentUser: String?
    
    //MARK: - Public methods
    func updateMainUserInfoInFirebase() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        guard let userMainInfo = UserMainInfoModel(from: CoreDataManager.shared.readUserMainInfo()) else { return }
        let localJSONStringModel = userMainInfo.convertToJSONString()
        self.fetchMainUserInfo { (fireBaseJSONString) in
            guard let fireBaseJsonStringModel = fireBaseJSONString else { return }
            if fireBaseJsonStringModel != localJSONStringModel {
                self.firebaseRef.child("user").child(userUid).setValue(["userMainInfo": localJSONStringModel])
            }
        }
    }
    
    //updating usermaininfo data from firebase to coredata if user logged in
    func updateLoggedInMainUserFromFirebase(completion: @escaping () -> Void) {
        self.fetchMainUserInfo(completion: { (fireBaseJSONString) in
            let sortedJSONString = fireBaseJSONString?.sorted(by: <)
            guard let fireBaseJsonStringModel = fireBaseJSONString else { return }
            if let userMainInfo = UserMainInfoModel(from: CoreDataManager.shared.readUserMainInfo()) {
                let localJSONStringModel = userMainInfo.convertToJSONString()?.sorted(by: <)
                if sortedJSONString != localJSONStringModel {
                    guard let data = fireBaseJsonStringModel.data(using: .utf8) else { return }
                    guard let mainInfo = try? JSONDecoder().decode(UserMainInfoModel.self, from: data) else {
                        completion()
                        return }
                    CoreDataManager.shared.updateUserMainInfo(to: mainInfo)
                    completion()
                } else {
                    completion()
                }
            } else {
                guard let data = fireBaseJsonStringModel.data(using: .utf8) else { return }
                guard let mainInfo = try? JSONDecoder().decode(UserMainInfoModel.self, from: data) else {
                    completion()
                    return }
                CoreDataManager.shared.updateUserMainInfo(to: mainInfo)
                completion()
            }
        })
    }
    
    //Updating mainuserinfo from firebase to coredata if users not loged in and do it right now
    func updateNotLogInUserFromFirebase(completion: @escaping () -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        self.firebaseRef.child("user").child(userUid).observeSingleEvent(of: .value, with: { (snapshot) in
           // guard let dictionaryValue = snapshot.value as? NSDictionary else { return }
            if let dictionaryValu = snapshot.value as? NSDictionary {
                self.fetchMainUserInfo { (fireBaseJSONString) in
                    guard let fireBaseJsonStringModel = fireBaseJSONString else { return }
                    guard let data = fireBaseJsonStringModel.data(using: .utf8) else { return }
                    guard let mainInfo = try? JSONDecoder().decode(UserMainInfoModel.self, from: data) else { return }
                    CoreDataManager.shared.updateUserMainInfo(to: mainInfo)
                    completion()
                }
            } else {
                self.firebaseRef.child("user").child(userUid).setValue(["userMainInfo": ""])
                completion()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
  
    func fetchMainUserInfo(completion: @escaping ((String?) -> Void)) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        self.firebaseRef.child("user").child(userUid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaryValue = snapshot.value as? NSDictionary else { return }
            guard let jsonString = dictionaryValue["userMainInfo"] as? String else { return }
            completion(jsonString)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
