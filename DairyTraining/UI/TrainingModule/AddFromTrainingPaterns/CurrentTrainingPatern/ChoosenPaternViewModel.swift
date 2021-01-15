
protocol ChoosenPaternViewModelProtocol: PaternNamingAlertDelegate {
    var exercises: [Exercise] { get }
    var patenrName: String { get }
    
    func createTraining()
    func addExerciseToCurrnetPatern()
    func backButtonPressed()
}

protocol ChoosenPaternViewModelInput: AnyObject {
    func exerciseWasAdedTopatern()
    func paternNameChanged(to name: String)
}

final class ChoosenPaternViewModel {
    
    //MARK: - Properties
    private let model: ChoosenPaternModelProtocol
    weak var view: ChoosenPaternView?
    
    //MARK: - Initialization
    init(model: ChoosenPaternModelProtocol) {
        self.model = model
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

// MARK: - ChoosenPaternViewModelProtocol
extension ChoosenPaternViewModel: ChoosenPaternViewModelProtocol {
    
    func backButtonPressed() {
        model.popViewController()
    }

    var patenrName: String {
        return model.patern.name
    }

    var exercises: [Exercise] {
        return convertTrainingModel(from: model.patern.exerciseArray)
    }
    
    func patrnNamingAlertOkPressedToRenamePatern(name: String) {
        model.renameTrainingPaternAlert(for: name)
    }

    func paternNamingAlertOkPressedToCreatePatern(name: String) {
        return
    }
    
    func createTraining() {
        model.createTrainingWithCurrentpatern(exercise: exercises)
    }
    
    func addExerciseToCurrnetPatern() {
        MainCoordinator.shared.coordinate(
            to:MuscleGroupsCoordinator.Target.muscularGrops(patern: .trainingPatern(trainingPatern: model.patern)))
    }
}

// MARK: - ChoosenPaternViewModelInput
extension ChoosenPaternViewModel: ChoosenPaternViewModelInput {
    
    func paternNameChanged(to name: String) {
        view?.changePaternName(to: name)
    }
    
    func exerciseWasAdedTopatern() {
        view?.reloadTable()
    }
}
