
import Foundation

protocol ExerciseListModelIterator: AnyObject {
    func addChoosenExerciseToList(_ exercise: Exercise)
    func removeChossenExerciseFromList(_ exercise: Exercise)
    func writeExerciseToTraining()
    func writeExerciseToTrainingPatern()
}

protocol ExerciseListModelOutput: AnyObject {
    func updateExerciseForDeltingListInfo(isEmty: Bool)
    func exerciseWasAddedToTraining()
}

final class ExerciseListModel {
    
    weak var output: ExerciseListModelOutput?
    
    private var exerciseListForAddingToTraining: [Exercise] = []
    private var trainingPatern: TrainingPaternManagedObject?
    
    init(trainingPatern: TrainingPaternManagedObject?) {
        self.trainingPatern = trainingPatern
    }
}

//MARK: - ExerciseListModelIterator
extension ExerciseListModel: ExerciseListModelIterator {
    
    func writeExerciseToTrainingPatern() {
        if let trainingPatern = self.trainingPatern {
            TrainingDataManager.shared.addExercicese(self.exerciseListForAddingToTraining,
                                                 to: trainingPatern)
        }
    }
    
    func writeExerciseToTraining() {
        if TrainingDataManager.shared.addExercisesToTrain(self.exerciseListForAddingToTraining) {
            NotificationCenter.default.post(
                name: .trainingListWasChanged,
                object: nil,
                userInfo: nil )
        } else {
            NotificationCenter.default.post(
                name: .trainingWasChanged,
                object: nil,
                userInfo: nil)
        }
        self.exerciseListForAddingToTraining.removeAll()
        self.output?.exerciseWasAddedToTraining()
    }
    
    func addChoosenExerciseToList(_ exercise: Exercise) {
        self.exerciseListForAddingToTraining.append(exercise)
        self.output?.updateExerciseForDeltingListInfo(isEmty: self.exerciseListForAddingToTraining.isEmpty)
    }
    
    func removeChossenExerciseFromList(_ exercise: Exercise) {
        self.exerciseListForAddingToTraining = self.exerciseListForAddingToTraining.filter({
            $0.name != exercise.name
        })
        self.output?.updateExerciseForDeltingListInfo(isEmty: self.exerciseListForAddingToTraining.isEmpty)
    }
}
