import Foundation

protocol TrainingListViewModelIteracting: AnyObject {
    func getTraining(for index: Int) -> TrainingManagedObject?
    var trainingCount: Int? { get }
    var isTrainingEmty: Bool { get }
    func trainingWasSelected(at index: Int)
    func trainingWasDeselected(at index: Int)
    func deleteSelectedTraining()
    func deselectAllTraining()
    func deleteChoosenTraining()
    func goToTraining(at index: Int)
    func goToMuscularList(with trainingEntityTarget: TrainingEntityTarget)
    func goToTrainingPaterns()
}

final class TrainingListViewModel {
    
    weak var view: TraininglistViewControllerIteractin?
    var model: TrainingListModel?
   // var router: TrainingListRouter?
    
    init(model: TrainingListModel) {
        self.model = model
    }
}

//MARK: - TrainingListViewModelIteracting
extension TrainingListViewModel: TrainingListViewModelIteracting {
    
    func goToMuscularList(with trainingEntityTarget: TrainingEntityTarget) {
        MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: trainingEntityTarget))
        //self.router?.pushExerciseListViewController()
    }

    func goToTrainingPaterns() {
        MainCoordinator.shared.coordinate(to: TrainingPaternsCoordinator.Target.trainingPaternsList)
        //self.router?.pushTrainingPaternsViewController()
    }
    
    func goToTraining(at index: Int) {
        guard let choosenTraining = self.model?.trainingList[index] else { return }
        MainCoordinator.shared.coordinate(
            to:TrainingModuleCoordinator.Target.choosenTraining(training: choosenTraining))
        //self.router?.pushTrainingViewController(for: choosenTraining)
    }
    
    func deleteChoosenTraining() {
        self.model?.deleteSelectedTraining()
    }
    
    func deleteSelectedTraining() {
        self.model?.deleteSelectedTraining()
    }
    
    func deselectAllTraining() {
        self.model?.deselectAllTraining()
    }
    
    func trainingWasDeselected(at index: Int) {
        self.model?.deselectTraining(at: index)
    }

    func trainingWasSelected(at index: Int) {
        self.model?.selectTraining(at: index)
    }
    
    var isTrainingEmty: Bool {
        return self.trainingCount != nil && self.trainingCount != 0 ? false : true
    }
    
    var trainingCount: Int? {
        return self.model?.trainingList.count
    }
    
    func getTraining(for index: Int) -> TrainingManagedObject? {
        guard let model = self.model else { return  nil }
        return model.trainingList[index]
    }
}

//MARK: - TrainigListModelOutput
extension TrainingListViewModel: TrainigListModelOutput {
    
    func chekTrainingForDeletingList(isEmty: Bool) {
        self.view?.setTrashButton(isActive: !isEmty)
    }
    
    func trainingListWasChanged() {
        self.view?.trainingListWasChanged()
    }
    
    func trainingWasChanged() {
        self.view?.trainingWasChanged()
    }
}
