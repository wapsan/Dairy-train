import Foundation

protocol TrainingModelIteracting: AnyObject {
    var isTrainingEditable: Bool { get }
    func loadTraininig()
    func getNameForExercice(at index: Int)
    func deleteExercice(at index: Int)
    func addAproach(with weight: Float, and reps: Int, to exerciseAtIndex: Int)
    func removeLatsAproach(at exerciseIndex: Int)
    func getAproachInfo(in exerciseIndex: Int, and aproachIndex: Int)
    func changeAproach(in exerciseIndex: Int, at aproachIndex: Int, weight: Float, reps: Int)
    func exerciseDone(at index: Int)
    func coordinateToMuscularGroupsScreen()
    func showStatisticForCurrentTraining()
    
    func popViewController()
}

protocol TrainingModelOutput: AnyObject {
    
    func setExerciceList(for training: [ExerciseManagedObject])
    func setTrainingDate(for training: TrainingManagedObject)
    func setDeletetingTrainingName(to name: String, at index: Int)
    func exerciceWasDeleted(at index: Int)
    func aproachWasDeleted(from exerciseList: [ExerciseManagedObject], atExrcise index: Int)
    func aproachWasAded(to exerciseList: [ExerciseManagedObject], at index: Int)
    func aproachWillChange(in exerciseIndex: Int, with weight: Float, and reps: Int, at aproachIndex: Int)
    func aproachWasChanged(in exerciseIndex: Int,
                           at aproachIndex: Int,
                           weight: Float,
                           reps: Int,
                           in exerciseList: [ExerciseManagedObject])
    func trainingWasChange()
    func trainingIsEmpty()
    func exerciseWasMarkedDone(at index: Int)
}

final class TrainingModel {
    
    private var training: TrainingManagedObject
    weak var output: TrainingModelOutput?
    var exerciceList: [ExerciseManagedObject] = []
    
    init(with train: TrainingManagedObject) {
        self.training = train
        self.exerciceList = train.exercicesArray
        self.registerObserverForTrainingChanging()
    }
    
    private func registerObserverForTrainingChanging() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasChanged),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    @objc private func trainingWasChanged() {
        guard let training = TrainingDataManager.shared.getTraingList().first else { return }
        self.exerciceList = training.exercicesArray
        self.output?.setExerciceList(for: self.exerciceList)
        self.output?.trainingWasChange()
    }
}

//MARK: - TrainingModelIteracting
extension TrainingModel: TrainingModelIteracting {
    
    func popViewController() {
        MainCoordinator.shared.popViewController()
    }
    
    func showStatisticForCurrentTraining() {
        MainCoordinator.shared.coordinate(to: TrainingModuleCoordinator.Target.statisticForCurrentTraining(training: training))
    }
    
    var isTrainingEditable: Bool {
        return training.isEditable
    }
    
    func coordinateToMuscularGroupsScreen() {
        MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .training))
    }
    
    func exerciseDone(at index: Int) {
        TrainingDataManager.shared.markExercise(exerciceList[index], as: true)
        output?.exerciseWasMarkedDone(at: index)
    }
    
    func changeAproach(in exerciseIndex: Int, at aproachIndex: Int, weight: Float, reps: Int) {
        let exercise = self.exerciceList[exerciseIndex]
        TrainingDataManager.shared.changeAproachAt(aproachIndex, in: exercise, with: weight, and: reps)
        self.output?.aproachWasChanged(in: exerciseIndex,
                                       at: aproachIndex,
                                       weight: weight,
                                       reps: reps,
                                       in: self.exerciceList)
    }
    
    func removeLatsAproach(at exerciseIndex: Int) {
        TrainingDataManager.shared.removeAproachIn(self.training.exercicesArray[exerciseIndex])
        self.output?.aproachWasDeleted(from: self.exerciceList, atExrcise: exerciseIndex)
    }
    
    func addAproach(with weight: Float, and reps: Int, to exerciseAtIndex: Int) {
        TrainingDataManager.shared.addAproachWith(weight,
                                             and: reps,
                                             to: self.training.exercicesArray[exerciseAtIndex])
        self.output?.aproachWasAded(to: self.exerciceList, at: exerciseAtIndex)
    }
    
    func deleteExercice(at index: Int) {
        let exercise = self.exerciceList[index]
        TrainingDataManager.shared.removeExercise(exercise, from: self.training)
        self.exerciceList.remove(at: index)
        if self.exerciceList.isEmpty {
            self.output?.trainingIsEmpty()
        }
        self.output?.setExerciceList(for: self.exerciceList)
        self.output?.exerciceWasDeleted(at: index)
    }
    
    func getAproachInfo(in exerciseIndex: Int, and aproachIndex: Int) {
        let aproach = self.exerciceList[exerciseIndex].aproachesArray[aproachIndex]
        self.output?.aproachWillChange(in: exerciseIndex, with: aproach.weight, and: Int(aproach.reps), at: aproachIndex)
    }
    
    func getNameForExercice(at index: Int) {
        let exercice = self.training.exercicesArray[index]
        self.output?.setDeletetingTrainingName(to: exercice.name, at: index)
    }
    
    func loadTraininig() {
        self.output?.setExerciceList(for: self.exerciceList)
        self.output?.setTrainingDate(for: self.training)
    }
}
