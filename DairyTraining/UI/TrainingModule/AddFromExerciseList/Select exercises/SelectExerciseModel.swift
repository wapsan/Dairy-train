import Foundation

protocol SelectExerciseModelOutput {
    var muscularGroupName: String { get }
    var muscularSubfroupList: [MuscleSubgroup.Subgroup] { get }
    var selectedExercises: [Exercise] { get }
    func add(exercise: Exercise)
    func remove(exercise: Exercise)
    func addSelectedExerciseToEntityTarget()
}

final class SelectExerciseModel {
    
    //MARK: - Module properties
    weak var viewModel: SelectesExerciseViewModelIteractor?
    
    //MARK: - Private properties
    private var exerciseListToAdd: [Exercise] = [] {
        didSet {
            viewModel?.updateSelectedExercise(to: exerciseListToAdd)
        }
    }
    private var _muscularSubgroupList: [MuscleSubgroup.Subgroup] = []
    private var _muscularGroupName: String
    private var trainingEntityTarget: TrainingEntityTarget
    private let exerciseService: PersistenceService
    
    //MARK: - Initialization
    init(muscularGroup: MuscleGroup.Group, trainingEntityTarget: TrainingEntityTarget, service: PersistenceService = PersistenceService()) {
        self.exerciseService = service
        self._muscularSubgroupList = MuscleSubgroup.init(for: muscularGroup).listOfSubgroups
        self.trainingEntityTarget = trainingEntityTarget
        self._muscularGroupName = muscularGroup.name
    }
    
    //MARK: - Public methods
    private func addExerciseToTraining() {
        if exerciseService.workout.isTodayWorkoutExist {
            exerciseService.workout.addExerciseToTodaysWorkout(exercise: exerciseListToAdd)
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
            
        } else {
            exerciseService.workout.createWorkout(with: exerciseListToAdd)
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
            
        }
    }
    
    private func addExerciseList(to trainingPatern: WorkoutTemplateMO) {
        exerciseService.workoutTemplates.addExercises(exercises: exerciseListToAdd, to: trainingPatern)
        NotificationCenter.default.post(name: .exerciseWasAdedToPatern, object: nil)
    }
}

//MARK: - SelectExerciseModelOutput
extension SelectExerciseModel: SelectExerciseModelOutput {
    
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
            NotificationCenter.default.post(name: .exerciseWasAdedToPatern, object: nil)
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
