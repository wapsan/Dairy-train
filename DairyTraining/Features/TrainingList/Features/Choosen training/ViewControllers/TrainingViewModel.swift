import Foundation

protocol TrainingViewModeInput: AnyObject {
    func loadTrain()
    func tryDeleteExercice(at index: Int)
    func deleteExercice(at index: Int)
    func removeLatsAproach(at exericeIndex: Int)
    func aproachWillChanged(in exerciceIndex: Int, and aproachIndex: Int)
}

final class TrainingViewModel {
    
    var model: TrainingModelIteracting?
    weak var view: TestTrainingViewControllerIteracting?
    
    var numberOfExercice: Int {
        self.exerciceList.count
    }
    var exerciceList: [ExerciseManagedObject] = []
    var trainingDate: String?
}

//MARK: - TrainingModelOutput
extension TrainingViewModel: TrainingModelOutput {
    
    func aproachWillChange(in exerciseIndex: Int, with weight: Float, and reps: Int, at aproachIndex: Int) {
    self.view?.showChangeAproachAlert(in: exerciseIndex, with: weight, reps: reps, at: aproachIndex)

    }
    
    func aproachWasChanged(in exerciseIndex: Int, at aproachIndex: Int, weight: Float, reps: Int, in exerciseList: [ExerciseManagedObject]) {
        self.exerciceList = exerciseList
        self.view?.aproachWasChanged(in: exerciseIndex, and: aproachIndex)
        self.view?.hideAproachAlert()
    }
    
    func aproachWasChanged(in exerciseIndex: Int, at aproachIndex: Int, weight: Float, reps: Int) {
        self.view?.aproachWasChanged(in: exerciseIndex, and: aproachIndex)
        self.view?.hideAproachAlert()
    }

    func aproachWasDeleted(from exerciseList: [ExerciseManagedObject], atExrcise index: Int) {
        self.view?.deleteLastAproach(inExerciseAt: index)
    }
    
    func aproachWasAded(to exerciseList: [ExerciseManagedObject], at index: Int) {
        self.exerciceList = exerciseList
        self.view?.addAproach(inExerciseAt: index)
        self.view?.hideAproachAlert()
    }
    
    func setExerciceList(for training: [ExerciseManagedObject]) {
        self.exerciceList = training
    }
    
    func setDeletetingTrainingName(to name: String, at index: Int) {
        self.view?.showDeleteTrainingAlert(for: index, with: name)
    }
    
    func exerciceWasDeleted(at index: Int) {
        self.view?.updateTraining(with: index)
    }
  
    func setTrainingDate(for training: TrainingManagedObject) {
        self.trainingDate = training.formatedDate
    }
}

//MARK: - TrainingViewModeIteracting
extension TrainingViewModel: TrainingViewModeInput {
    
    func aproachWillChanged(in exerciceIndex: Int, and aproachIndex: Int) {
        self.model?.getAproachInfo(in: exerciceIndex, and: aproachIndex)
    }
    
    func removeLatsAproach(at exericeIndex: Int) {
        self.model?.removeLatsAproach(at: exericeIndex)
    }

    func deleteExercice(at index: Int) {
        self.model?.deleteExercice(at: index)
    }

    func tryDeleteExercice(at index: Int) {
        self.model?.getNameForExercice(at: index)
    }
    
    func loadTrain() {
        self.model?.loadTraininig()
    }
}
 
//MARK: - NewAproachAlertDelegate
extension TrainingViewModel: NewAproachAlertDelegate {
    
    func changeAproachAlertOkPressed(changeAproachAlert: DTNewAproachAlert,
                                     at aproachIndex: Int,
                                     and exerciseIndex: Int,
                                     with weight: Float,
                                     and reps: Int) {
        self.model?.changeAproach(in: exerciseIndex, at: aproachIndex, weight: weight, reps: reps)
    }
    
    func newAproachAlertOkPressed(newAproachAlert: DTNewAproachAlert,
                                  with weight: Float,
                                  and reps: Int,
                                  and exerciceIndex: Int) {
        self.model?.addAproach(with: weight, and: reps, to: exerciceIndex)
    }
    
    func newAproachAlertCancelPressed(newAproachAlert: DTNewAproachAlert) {
        self.view?.hideAproachAlert()
    }
}
