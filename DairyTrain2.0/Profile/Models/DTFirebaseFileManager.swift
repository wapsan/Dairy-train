import Foundation
import Firebase

class DTFirebaseFileManager {
    
    //MARK: - Singletone
    static let shared = DTFirebaseFileManager()
    
    //MARK: - Private properties
    private lazy var mainProfileInfo = ProfileInfoFileManager.shared
    private lazy var firebaseRef = Database.database().reference()
    private lazy var currentUser = Auth.auth().currentUser
    
    //MARK: - Public methods
    func updateMainUserInfo() {
        guard let userUid = self.currentUser?.uid else { return }
        guard let encodedData = self.mainProfileInfo.encodedProfileInfo else { return }
        guard let localJsonString = String(data: encodedData, encoding: .utf8) else { return }
        self.fetchMainUserInfo(completion: { (cloudJsonString) in
            guard let cloudJsonString = cloudJsonString else { return }
            if cloudJsonString != localJsonString {
                print("Local data and cloud data is not equal")
                self.firebaseRef.child("user").child(userUid).setValue(["userMainInfo": localJsonString])
            } else {
                print("Local data and cloud data is equal")
            }
        })
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
