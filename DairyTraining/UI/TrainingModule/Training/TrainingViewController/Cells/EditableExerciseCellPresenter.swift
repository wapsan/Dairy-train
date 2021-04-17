import UIKit

protocol EditableExerciseCellPresenterProtocol: NewAproachAlertDelegate {
    
    var itemCount: Int { get }
    
    func approach(at indexPath: IndexPath) -> ApproachMO
    func deleteLastApproach()
    func loadAproaches()
    
    func markExerciseAsDone()
}

protocol EditableExerciseCellPresenterOutput: AnyObject {
    func reloadItem(at indexPath: IndexPath)
    func insertItem(at indexPath: IndexPath)
    func deleteItem(at indexPath: IndexPath)
    func hideAlert()
    
    func exerciseIsDonde(isDone: Bool)
}

final class EditableExerciseCellPresenter {
    
    private let persistenceService = PersistenceService()
    weak var output: EditableExerciseCellPresenterOutput?
    var exercise: ExerciseMO
    var approaches: [ApproachMO] = []
    
    init(exercise: ExerciseMO) {
        self.exercise = exercise
    }
    
    private func updateApproach(at indexPath: IndexPath, for approach: Approach) {
        let approachForUpdate = approaches[indexPath.row]
        let updatedApproach = persistenceService.approaches.updateApproach(oldApproach: approachForUpdate, for: approach)
        approaches.remove(at: indexPath.row)
        approaches.insert(updatedApproach, at: indexPath.row)
        output?.reloadItem(at: indexPath)
    }
    
     private  func addApproach(aproach: Approach, to exercise: ExerciseMO) {
        let newApproach = persistenceService.approaches.addApproach(approach: aproach, to: exercise)
         approaches.append(newApproach)
         let indexPath = IndexPath(row: approaches.count - 1, section: 0)
         output?.insertItem(at: indexPath)
     }
    
    private func checkIsExerciseDone() {
        output?.exerciseIsDonde(isDone: exercise.isDone)
    }
}


extension EditableExerciseCellPresenter: EditableExerciseCellPresenterProtocol {
    
    func markExerciseAsDone() {
        persistenceService.exercise.markExerciseAsDone(exercise: exercise)
        output?.exerciseIsDonde(isDone: true)
    }
    
    func newAproachAlertOkPressed(newAproachAlert: DTNewAproachAlert, with weight: Float, and reps: Int, and exerciceIndex: Int) {
        let newAproach = Approach(index: approaches.count - 1, reps: reps, weight: weight)
        addApproach(aproach: newAproach, to: exercise)
    }
    
    func changeAproachAlertOkPressed(changeAproachAlert: DTNewAproachAlert, at aproachIndex: Int, and exerciseIndex: Int, with weight: Float, and reps: Int) {
        let indexPath = IndexPath(row: aproachIndex, section: 0)
        let approach = Approach(index: aproachIndex, reps: reps, weight: weight)
        updateApproach(at: indexPath, for: approach)
    }
    
    func newAproachAlertCancelPressed(newAproachAlert: DTNewAproachAlert) {
        output?.hideAlert()
    }
    
    
    func loadAproaches() {
        self.approaches = persistenceService.approaches.fetchApproaches(for: exercise)
        self.checkIsExerciseDone()
    }
    
    
    var itemCount: Int {
        return approaches.count
    }
    
    func approach(at indexPath: IndexPath) -> ApproachMO {
        return approaches[indexPath.row]
    }
    
    func deleteLastApproach() {
        guard let lastApproach = approaches.last else { return }
        persistenceService.approaches.deleteApproach(approach: lastApproach)
        approaches.removeLast()
        let indexPath = IndexPath(row: approaches.count , section: 0)
        output?.deleteItem(at: indexPath)
    }
}
 
