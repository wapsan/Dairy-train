
import Foundation

protocol ExerciseListModelIterator: AnyObject {
    func addChoosenExerciseToList(_ exercise: Exercise)
    func removeChossenExerciseFromList(_ exercise: Exercise)
    func writeExerciseToTraining()
}

protocol ExerciseListModelOutput: AnyObject {
    func updateExerciseForDeltingListInfo(isEmty: Bool)
    func exerciseWasAddedToTraining()
}

final class ExerciseListModel {
    
    weak var output: ExerciseListModelOutput?
    
    private var exerciseListForAddingToTraining: [Exercise] = []
}

//MARK: - ExerciseListModelIterator
extension ExerciseListModel: ExerciseListModelIterator {
    
    func writeExerciseToTraining() {
        if CoreDataManager.shared.addExercisesToTrain(self.exerciseListForAddingToTraining) {
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
