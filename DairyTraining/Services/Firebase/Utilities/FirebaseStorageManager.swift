import Foundation
import Firebase


struct TrainingProgramsLevelModel {
    let title: String
    let imageURL: String
}

struct TrainingProgramms {
    let title: String
    let exercise: [Exercise] = []
}



final class FirebaseStorageMnager {
    
    private lazy var dataBase = Firestore.firestore()
    
    func getListOfTraining(for levelOfTraining: LevelOfTrainingModel,
                           completion: @escaping (Result<[TrainingProgramms], Error>) -> Void) {
        var info: [TrainingProgramms] = []
        dataBase.collection("beginner_en").getDocuments { (snapshot, error) in
            if let error = error { completion(.failure(error)) }
            guard let documents = snapshot?.documents else { return }
            documents.forEach({
                guard let title = $0.data()["training_name"] as? String else { return }
                info.append(TrainingProgramms(title: title))
            })
            completion(.success(info))
        }
    }
    
    func getTrainingLevelsSections(completion: @escaping (Result<[TrainingProgramms], Error>) -> Void) {
        var info: [TrainingProgramms] = []
        dataBase.collection("beginner_en").getDocuments { (snapshot, error) in
            if let error = error { completion(.failure(error)) }
            guard let documents = snapshot?.documents else { return }
            documents.forEach({
                guard let title = $0.data()["training_name"] as? String else { return }
                info.append(TrainingProgramms(title: title))
            })
            completion(.success(info))
        }
    }
    
    
    
}
