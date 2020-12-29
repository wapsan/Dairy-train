import Foundation

protocol TrainingViewModeProtocol: AnyObject {
    var trainingDate: String? { get }
    var exerciseCount: Int { get }
    var exerciseList: [ExerciseManagedObject] { get }
    var isTrainingEditable: Bool { get }
    
    func loadTrain()
    func tryDeleteExercice(at index: Int)
    func showStatisticsForExercise(at index: Int)
    func deleteExercice(at index: Int)
    func removeLatsAproach(at exericeIndex: Int)
    func aproachWillChanged(in exerciceIndex: Int, and aproachIndex: Int)
    func exerciseDone(at index: Int)
    func doneExercise()
    func isExerciseEditable(at index: Int) -> Bool
    func footerButtonPressed()
    func statisticsButtonPressed()
}

final class TrainingViewModel {
    
    // MARK: - Module Properties
    private var model: TrainingModelIteracting
    weak var view: TrainingView?
    
    // MARK: - Properties
    private var exerciseDoneIndex: Int?
    private var _exerciceList: [ExerciseManagedObject] = []
    private var _trainingDate: String?
    
    // MARK: - Initialization
    init(model: TrainingModelIteracting) {
        self.model = model
    }
}

//MARK: - TrainingModelOutput
extension TrainingViewModel: TrainingModelOutput {
    
    func exerciseWasMarkedDone(at index: Int) {
        view?.reloadCell(at: index)
    }
    
    func trainingIsEmpty() {
        MainCoordinator.shared.popViewController()
    }
    
    func trainingWasChange() {
        self.view?.reloadTable()
    }
    
    func aproachWillChange(in exerciseIndex: Int, with weight: Float, and reps: Int, at aproachIndex: Int) {
        self.view?.showChangeAproachAlert(in: exerciseIndex, with: weight, reps: reps, at: aproachIndex)
    }
    
    func aproachWasChanged(in exerciseIndex: Int, at aproachIndex: Int, weight: Float, reps: Int, in exerciseList: [ExerciseManagedObject]) {
        self._exerciceList = exerciseList
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
        self._exerciceList = exerciseList
        self.view?.addAproach(inExerciseAt: index)
        self.view?.hideAproachAlert()
    }
    
    func setExerciceList(for training: [ExerciseManagedObject]) {
        self._exerciceList = training
    }
    
    func setDeletetingTrainingName(to name: String, at index: Int) {
        self.view?.showDeleteTrainingAlert(for: index, with: name)
    }
    
    func exerciceWasDeleted(at index: Int) {
        view?.deleteCell(at: index)
    }
  
    func setTrainingDate(for training: TrainingManagedObject) {
        self._trainingDate = training.formatedDate
    }
}

//MARK: - TrainingViewModeIteracting
extension TrainingViewModel: TrainingViewModeProtocol {
    
    func statisticsButtonPressed() {
        model.showStatisticForCurrentTraining()
    }
    
    var isTrainingEditable: Bool {
        return model.isTrainingEditable
    }
    
    func footerButtonPressed() {
        model.coordinateToMuscularGroupsScreen()
    }
    
    func isExerciseEditable(at index: Int) -> Bool {
        return !_exerciceList[index].isDone
    }
    
    var exerciseList: [ExerciseManagedObject] {
        return _exerciceList
    }
    
    var exerciseCount: Int {
        return _exerciceList.count
    }

    var trainingDate: String? {
        return _trainingDate
    }
    
    func doneExercise() {
        guard let exerciseIndexToMark = self.exerciseDoneIndex else { return }
        model.exerciseDone(at: exerciseIndexToMark)
    }
    
    
    func exerciseDone(at index: Int) {
        exerciseDoneIndex = index
        view?.showAlertForDoneExercise()
    }
    
    func showStatisticsForExercise(at index: Int) {
        let choosenExerciseName = _exerciceList[index].name
        let choosenExerciseDate = _exerciceList[index].date
        MainCoordinator.shared.coordinate(to: TrainingModuleCoordinator.Target.statisticsForChosenExercise(name: choosenExerciseName, exerciseDate: choosenExerciseDate))
    }
    
    func aproachWillChanged(in exerciceIndex: Int, and aproachIndex: Int) {
        self.model.getAproachInfo(in: exerciceIndex, and: aproachIndex)
    }
    
    func removeLatsAproach(at exericeIndex: Int) {
        self.model.removeLatsAproach(at: exericeIndex)
    }

    func deleteExercice(at index: Int) {
        self.model.deleteExercice(at: index)
    }

    func tryDeleteExercice(at index: Int) {
        self.model.getNameForExercice(at: index)
    }
    
    func loadTrain() {
        self.model.loadTraininig()
    }
}
 
//MARK: - NewAproachAlertDelegate
extension TrainingViewModel: NewAproachAlertDelegate {
    
    func changeAproachAlertOkPressed(changeAproachAlert: DTNewAproachAlert,
                                     at aproachIndex: Int,
                                     and exerciseIndex: Int,
                                     with weight: Float,
                                     and reps: Int) {
        self.model.changeAproach(in: exerciseIndex, at: aproachIndex, weight: weight, reps: reps)
    }
    
    func newAproachAlertOkPressed(newAproachAlert: DTNewAproachAlert,
                                  with weight: Float,
                                  and reps: Int,
                                  and exerciceIndex: Int) {
        self.model.addAproach(with: weight, and: reps, to: exerciceIndex)
    }
    
    func newAproachAlertCancelPressed(newAproachAlert: DTNewAproachAlert) {
        self.view?.hideAproachAlert()
    }
}
