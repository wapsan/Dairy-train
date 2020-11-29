import Foundation

protocol SelectExerciseNewModelOutput {
    var muscularGroupName: String { get }
    var muscularSubfroupList: [MuscleSubgroup.Subgroup] { get }
    var selectedExercises: [Exercise] { get }
    func add(exercise: Exercise)
    func remove(exercise: Exercise)
    func addSelectedExerciseToEntityTarget()
}

final class SelectExerciseNewModel {
    
    //MARK: - Module properties
    weak var viewModel: SelectesExerciseNewViewModelIteractor?
    
    //MARK: - Private properties
    private var exerciseListToAdd: [Exercise] = [] {
        didSet {
            viewModel?.updateSelectedExercise(to: exerciseListToAdd)
        }
    }
    private var _muscularSubgroupList: [MuscleSubgroup.Subgroup] = []
    private var _muscularGroupName: String
    private var trainingEntityTarget: TrainingEntityTarget
    
    //MARK: - Initialization
    init(muscularGroup: MuscleGroup.Group, trainingEntityTarget: TrainingEntityTarget) {
        self._muscularSubgroupList = MuscleSubgroup.init(for: muscularGroup).listOfSubgroups
        self.trainingEntityTarget = trainingEntityTarget
        self._muscularGroupName = muscularGroup.name
    }
    
    //MARK: - Public methods
    private func addExerciseToTraining() {
        if  TrainingDataManager.shared.addExercisesToTrain(exerciseListToAdd) {
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        } else {
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
        }
    }
    
    private func addExerciseList(to trainingPatern: TrainingPaternManagedObject) {
        TrainingDataManager.shared.addExercicese(exerciseListToAdd,
                                                 to: trainingPatern)
    }
}

//MARK: - SelectExerciseModelOutput
extension SelectExerciseNewModel: SelectExerciseNewModelOutput {
    
    var muscularGroupName: String {
        return _muscularGroupName
    }
    
    func addSelectedExerciseToEntityTarget() {
        switch trainingEntityTarget {
        case .training:
            addExerciseToTraining()
        case .trainingPatern(trainingPatern: let trainingPatern):
            guard let trainingPatern = trainingPatern else { return }
            addExerciseList(to: trainingPatern)
        }
        viewModel?.exerciseWasAdded()
    }
    
    var selectedExercises: [Exercise] {
        return exerciseListToAdd
    }
    
    func remove(exercise: Exercise) {
        exerciseListToAdd = exerciseListToAdd.filter({ $0.name != exercise.name })
    }
    
    
    func add(exercise: Exercise) {
        exerciseListToAdd.append(exercise)
    }
    
    var muscularSubfroupList: [MuscleSubgroup.Subgroup] {
        self._muscularSubgroupList
    }
}
