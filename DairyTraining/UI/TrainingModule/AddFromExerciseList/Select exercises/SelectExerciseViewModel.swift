import Foundation

protocol SelectExerciseViewModelOutput {
    var muscularSubgroupsTitles: [String] { get }
    var exerciseList: [Exercise] { get }
    var selectedExercise: [Exercise] { get }
    var muscularGroupName: String { get }
    func muscularSubgtoupWacChanged(to index: Int)
    func exerciseWasSelected(at index: Int)
    func exerciseWasDeselected(at index: Int)
    func addSelectesExercisesToTraining()
}

protocol SelectesExerciseViewModelIteractor: AnyObject {
    func updateSelectedExercise(to exercise: [Exercise])
    func exerciseWasAdded()
}

final class SelectExerciseViewModel {
    
    //MARK: - Module properties
    weak var view: SelectExerciseViewIteractor?
    private let model: SelectExerciseModelOutput
    
    //MARK: - Private properties
    private var _selectedExercises: [Exercise] = [] {
        didSet {
            view?.updateAddButtonState(to: !_selectedExercises.isEmpty)
        }
    }
    private var currentExercises: [Exercise] = [] {
        didSet {
            view?.muscularSubgroupWasChanged()
        }
    }
    
    //MARK: - Initialization
    init(model:SelectExerciseModelOutput ) {
        self.model = model
    }
}

//MARK: - SelectExerciseViewModelOutput
extension SelectExerciseViewModel: SelectExerciseViewModelOutput {
    
    func addSelectesExercisesToTraining() {
        model.addSelectedExerciseToEntityTarget()
    }

    var muscularGroupName: String {
        return model.muscularGroupName
    }
    
    var selectedExercise: [Exercise] {
        return _selectedExercises
    }

    func exerciseWasSelected(at index: Int) {
        model.add(exercise: currentExercises[index])
    }
    
    func exerciseWasDeselected(at index: Int) {
        model.remove(exercise: currentExercises[index])
    }
    
    var exerciseList: [Exercise] {
        return currentExercises
    }
    
    func muscularSubgtoupWacChanged(to index: Int) {
        let currentMuscularSubgroup = model.muscularSubfroupList[index]
        currentExercises = ExersiceModel(for: currentMuscularSubgroup).listOfExercices
        
    }
    
    var muscularSubgroupsTitles: [String] {
        return model.muscularSubfroupList.map({ $0.name })
    }
}

//MARK: - SelectesExerciseViewModelInput
extension SelectExerciseViewModel: SelectesExerciseViewModelIteractor {
    
    func exerciseWasAdded() {
        view?.exerciseWasAdded()
    }

    func updateSelectedExercise(to exercise: [Exercise]) {
        _selectedExercises = exercise
    }
}
