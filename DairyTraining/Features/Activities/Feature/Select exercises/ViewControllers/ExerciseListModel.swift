
import Foundation

protocol ExerciseListModelIterator: AnyObject {
    func addChoosenExerciseToList(_ exercise: Exercise)
    func removeChossenExerciseFromList(_ exercise: Exercise)
}

protocol ExerciseListModelOutput: AnyObject {
    func updateExerciseForDeltingListInfo(isEmty: Bool)
}

final class ExerciseListModel {
    
    weak var output: ExerciseListModelOutput?
    
    private var exerciseListForAddingToTraining: [Exercise] = []
    
}


extension ExerciseListModel: ExerciseListModelIterator {
    
    func addChoosenExerciseToList(_ exercise: Exercise) {
       
        self.exerciseListForAddingToTraining.append(exercise)
         print(self.exerciseListForAddingToTraining.count)
        self.output?.updateExerciseForDeltingListInfo(isEmty: self.exerciseListForAddingToTraining.isEmpty)
    }
    
    func removeChossenExerciseFromList(_ exercise: Exercise) {
        
        self.exerciseListForAddingToTraining = self.exerciseListForAddingToTraining.filter({
            $0.name != exercise.name
        })
        print(self.exerciseListForAddingToTraining.count)
        self.output?.updateExerciseForDeltingListInfo(isEmty: self.exerciseListForAddingToTraining.isEmpty)
    }
}
