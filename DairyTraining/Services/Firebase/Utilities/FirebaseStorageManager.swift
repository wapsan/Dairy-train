import Foundation
import Firebase


struct TrainingProgramsLevelModel {
    let title: String
    let imageURL: String
}

struct TrainingProgramms {
    let title: String
    let imageURL: URL?
    let exercise: [Exercise] = []
}



final class FirebaseStorageMnager {
    
    private lazy var dataBase = Firestore.firestore()
    private lazy var storage = Storage.storage()
    func getListOfTraining(for levelOfTraining: LevelOfTrainingModel,
                           completion: @escaping (Result<[TrainingProgramms], Error>) -> Void) {
        var info: [TrainingProgramms] = []
        dataBase.collection(levelOfTraining.id).getDocuments { (snapshot, error) in
            if let error = error { completion(.failure(error)) }
            guard let documents = snapshot?.documents else { return }
            documents.forEach({
                guard let title = $0.data()["training_name"] as? String,
                      let imageURL = $0.data()["image_url"] as? String else { return }
           //     if imageURL != "" {
                    let imageURLs = self.storage.reference().child(imageURL)
                    imageURLs.downloadURL { (url, error) in
                        info.append(TrainingProgramms(title: title, imageURL: url))
                        completion(.success(info))
                    }
               // }
              //  info.append(TrainingProgramms(title: title, imageURL: nil))
                
            })
          //  completion(.success(info))
        }
    }
    
//    func getTrainingLevelsSections(completion: @escaping (Result<[TrainingProgramms], Error>) -> Void) {
//        var info: [TrainingProgramms] = []
//        dataBase.collection("beginner_en").getDocuments { (snapshot, error) in
//            if let error = error { completion(.failure(error)) }
//            guard let documents = snapshot?.documents else { return }
//            documents.forEach({
//                guard let title = $0.data()["training_name"] as? String else { return }
//                info.append(TrainingProgramms(title: title))
//            })
//            completion(.success(info))
//        }
//    }
    
    
    
}
