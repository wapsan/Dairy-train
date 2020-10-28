import RxSwift
import RxCocoa

final class ChoosenPaternViewModel {
    
    //MARK: - Properties
    var model: ChoosenPaternModel
    var router: ChoosenPaternRouter?
    var paternNameo: BehaviorRelay<String> = BehaviorRelay(value: "")
    var paternsExercise: BehaviorRelay<[Exercise]> = BehaviorRelay(value: [])
    
    // MARK: - Private properties
    private var disposeBag = DisposeBag()
    
    //MARK: - Initialization
    init(model: ChoosenPaternModel) {
        self.model = model
        self.model.paternNameo
            .asObservable()
            .bind(to: paternNameo)
            .disposed(by: disposeBag)
        self.model.paternExercises
            .asObservable()
            .map({ self.convertTrainingModel(from: $0) })
            .bind(to: paternsExercise)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func createTraining() {
        model.createTrainingWithCurrentpatern(exercise: paternsExercise.value)
    }
    
    func addExerciseToCurrnetPatern() {
        router?.pushMuscleGroupViewController(with: model.trainingPatern)
    }
}

//MARK: - Private
private extension ChoosenPaternViewModel {
    
    func convertTrainingModel(from exerciseArray: [ExerciseManagedObject]) -> [Exercise] {
        var exerciseList: [Exercise] = []
        exerciseArray.forEach({
            guard let subgroup = MuscleSubgroup.Subgroup.init(rawValue: $0.subgroupName) else { return }
            let exercise = Exercise(name: $0.name, subgroup: subgroup)
            exerciseList.append(exercise)
        })
        return exerciseList
    }
}

// MARK: - PaternNamingAlertDelegate
extension ChoosenPaternViewModel: PaternNamingAlertDelegate {
    
    func patrnNamingAlertOkPressedToRenamePatern(name: String) {
        model.renameTrainingPaternAlert(for: name)
    }

    func paternNamingAlertOkPressedToCreatePatern(name: String) {
        return
    }
}
