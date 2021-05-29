import Foundation
import Firebase
import FirebaseFirestore


struct TrainingProgramsLevelModel {
    let title: String
    let imageURL: String
}

struct SpecialWorkout {
    let title: String
    let description: String
    let level: String
    let workoutID: String
    var image: UIImage? = nil
    var exercise: [Exercise] = []
    let imageURL: URL?
    
    mutating func setExercises(exercises: [Exercise]) {
        self.exercise = exercises
    }
}

fileprivate struct WorkoutKey {
    static let name = "name"
    static let imagePath = "image_path"
    static let description = "description"
}

fileprivate struct Exercisekey {
    static let name = "name"
    static let subgroup = "subgroup_name"
    static let sets = "sets"
    static let reps = "reps"
}



final class FirebaseStorageMnager {
    
    private lazy var dataBase = Firestore.firestore()
    private lazy var storage = Storage.storage()
    
    private lazy var maxDataSize: Int64 = 4 * 1024 * 1024
    private let workoutsPath = "ready_workouts_"
    private let workoutsCollectionPath = "workouts"
    
    private var readyWorkoutsLanguagePath: String {
        return workoutsPath + "en"//(Locale.current.languageCode ?? "en")
    }
    
    func getListOfTraining(for levelOfTraining: TrainingLevelsModel.Level,
                           completion: @escaping (Result<[SpecialWorkout], Error>) -> Void) {
        var info: [SpecialWorkout] = []
        
        dataBase
            .collection(readyWorkoutsLanguagePath)
            .document(levelOfTraining.documentID)
            .collection(workoutsCollectionPath)
            .getDocuments { (snapshot, error) in
                guard let workouts = snapshot?.documents else { return }
            
                workouts.forEach({ workout in
                    guard let workoutTitle = workout.data()[WorkoutKey.name] as? String,
                          let imageURL = workout.data()[WorkoutKey.imagePath] as? String,
                          let description = workout.data()[WorkoutKey.description] as? String else { return }
                    
                          let documentID = workout.documentID
                    
                    let imageStorageRef = self.storage.reference(withPath: imageURL)
                    
                    imageStorageRef.downloadURL { (url, error) in
                        info.append(SpecialWorkout(title: workoutTitle,
                                                   description: description,
                                                   level: levelOfTraining.documentID,
                                                   workoutID: documentID,
                                                   image: nil, imageURL: url))
                        completion(.success(info))
                    }
                    
                })
            }
    }
    
    func getListOfExercise(for workout: SpecialWorkout, completion: @escaping (Result<[Exercise], Error>) -> Void) {
        var exercisesZ: [Exercise] = []
        
        dataBase
            .collection(readyWorkoutsLanguagePath)
            .document(workout.level)
            .collection(workoutsCollectionPath)
            .document(workout.workoutID)
            .collection("exercises")
            .getDocuments { (snapshot, erro) in
                guard let exercises = snapshot?.documents else { return }
                exercises.forEach({ exercise in
                    guard let exerciseName = exercise.data()[Exercisekey.name] as? String,
                          let exerciseSubgroupRawValue = exercise.data()[Exercisekey.subgroup] as? String,
                          let sets = exercise.data()[Exercisekey.sets] as? Int,
                          let reps = exercise.data()[Exercisekey.reps] as? Int,
                          let exerciseSubgroup = MuscleSubgroup.Subgroup.init(rawValue: exerciseSubgroupRawValue) else { return }
                    let exercisePromt = ExercisePrompt(sets: sets, reps: reps)
                    exercisesZ.append(Exercise(name: exerciseName, subgroup: exerciseSubgroup, exercisePrompt: exercisePromt))
                })
                completion(.success(exercisesZ))
            }
        
    }
    
    
}
