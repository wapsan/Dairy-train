import Foundation

protocol WorkoutViewModeProtocol {
    var trainingDate: String? { get }
    var exerciseCount: Int { get }
    var exerciseList: [ExerciseManagedObject] { get }
    var isTrainingEditable: Bool { get }
    
    func loadTrain()
    func tryDeleteExercice(at index: Int)
    func showStatisticsForExercise(at index: Int)
    func removeLatsAproach(at exericeIndex: Int)
    func aproachWillChanged(in exerciceIndex: Int, and aproachIndex: Int)
    func exerciseDone(at index: Int)
    func doneExercise()
    func isExerciseEditable(at index: Int) -> Bool
    func footerButtonPressed()
    func statisticsButtonPressed()
    
    func backButtonPressed() 
}

final class WorkoutViewModel {
    
    // MARK: - Module Properties
    private var model: WorkoutModelProtocol
    weak var view: WorkoutViewProtocol?
    
    // MARK: - Properties
    private var exerciseDoneIndex: Int?
    private var _exerciceList: [ExerciseManagedObject] = []
    private var _trainingDate: String?
    var router: WorkoutRouterProtocol?
    
    // MARK: - Initialization
    init(model: WorkoutModelProtocol) {
        self.model = model
    }
}

//MARK: - TrainingModelOutput
extension WorkoutViewModel: WorkoutModelOutput {
    
    func exerciseWasMarkedDone(at index: Int) {
        view?.reloadCell(at: index)
    }
    
    func trainingIsEmpty() {
        router?.popViewController()
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
    
    func exerciceWasDeleted(at index: Int) {
        view?.deleteCell(at: index)
    }
  
    func setTrainingDate(for training: TrainingManagedObject) {
        self._trainingDate = training.formatedDate
    }
}

//MARK: - TrainingViewModeIteracting
extension WorkoutViewModel: WorkoutViewModeProtocol {
    
    func backButtonPressed() {
        router?.popViewController()
    }
    
    func statisticsButtonPressed() {
        router?.showCurrentWorkoutStatisticsScreen(for: model.currentWorkout)
    }
    
    var isTrainingEditable: Bool {
        return model.isTrainingEditable
    }
    
    func footerButtonPressed() {
        router?.presentExerciseFlow()
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
        let choosenExercise = _exerciceList[index]
        router?.showExerciseHistoryStatisticsScreen(for: choosenExercise)
    }
    
    func aproachWillChanged(in exerciceIndex: Int, and aproachIndex: Int) {
        self.model.getAproachInfo(in: exerciceIndex, and: aproachIndex)
    }
    
    func removeLatsAproach(at exericeIndex: Int) {
        self.model.removeLatsAproach(at: exericeIndex)
    }

    func tryDeleteExercice(at index: Int) {
        let exerciseNameForDeleting = exerciseList[index].name
        router?.showAlert(title: "Delete \(exerciseNameForDeleting)?",
                          message: "Are you sure?",
                          completion: {[weak self] in self?.model.deleteExercice(at: index)})
    }
    
    func loadTrain() {
        self.model.loadTraininig()
    }
}
 
//MARK: - NewAproachAlertDelegate
extension WorkoutViewModel: NewAproachAlertDelegate {
    
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
