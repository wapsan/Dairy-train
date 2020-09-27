import Foundation

final class ExerciseListViewModel {
    
    //MARK: - Module properties
    var model: ExerciseListModelIterator?
    weak var view: ExerciseListViewPresenter?
    
    //MARK: - Properties
    private(set) var exerciseList: [Exercise]
    private(set) var subgroupTitle: String
    
    //MARK: - Initialization
    init(with exerciseList: [Exercise], and subgroupTitle: String) {
        self.exerciseList = exerciseList
        self.subgroupTitle = subgroupTitle
    }
    
    //MARK: - Public methods
    func exerciseWasSelected(at index: Int) {
        let selectedExercise = exerciseList[index]
        self.model?.addChoosenExerciseToList(selectedExercise)
    }
    
    func exerciseWasDeselect(at index: Int) {
        let deselectedExercise = exerciseList[index]
        self.model?.removeChossenExerciseFromList(deselectedExercise)
    }
    
    func writeExerciseToTraining() {
        self.model?.writeExerciseToTraining()
    }
}

//MARK: - ExerciseListModelOutput
extension ExerciseListViewModel: ExerciseListModelOutput {
    
    func exerciseWasAddedToTraining() {
        self.view?.apdateUIAfterExerciseAdding()
    }
    
    func updateExerciseForDeltingListInfo(isEmty: Bool) {
        self.view?.updateAddButton(isActive: isEmty)
    }
}
