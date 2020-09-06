import UIKit

final class ExercicesListViewControllerOld: MuscleGroupsViewController {
    
    
    //MARK: - Private properties
    private lazy var navigationTittle = ""
    private lazy var exercices: [Exercise] = []
    private lazy var selectedExercices: [Exercise] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddExercicesButton()
        self.setUpNavigationItem()
        self.setUpTableView()
    }
    
    //MARK: - Private methods
    private func setAddExercicesButton() {
        let addButoon = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.addExercicesButtonTouched))
        self.navigationItem.rightBarButtonItem = self.selectedExercices.isEmpty ? nil : addButoon
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.title = NSLocalizedString(self.navigationTittle, comment: "") 
    }
    
    private func setUpTableView() {
        self.tableView.allowsMultipleSelection = true
    }
    
    private func deselectAllRows() {
        guard let indexPaths = self.tableView.indexPathsForSelectedRows else { return }
        for indexPath in indexPaths {
            if let cell = self.tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
                cell.setUnselectedBackgroundColor()
            }
        }
        self.selectedExercices.removeAll()
        self.tableView.reloadData()
    }
    
    private func addExercicesComplition() {
        if CoreDataManager.shared.addExercisesToTrain(self.selectedExercices) {
            NotificationCenter.default.post(
                name: .trainingListWasChanged,
                object: nil,
                userInfo: ["Trains": CoreDataManager.shared.fetchTrainingList()] )
        } else {
            NotificationCenter.default.post(
                name: .trainingWasChanged,
                object: nil,
                userInfo: ["Train": CoreDataManager.shared.fetchTrainingList()[0]])
        }
        self.showAddedAllert()
    }
    
    private func showAddExerciceAllert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: nil,
                                            message: LocalizedString.alertAddThisExercisesToTrain,
                                            cancelTitle: LocalizedString.cancel,
                                            okTitle: LocalizedString.ok,
                                            style: .alert,
                                            completion: { [weak self] in
                                                guard let self = self else { return }
                                                self.addExercicesComplition() })
    }
    
    private func showAddedAllert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: nil,
                                            message: LocalizedString.exercisesAdded,
                                            cancelTitle: nil,
                                            okTitle: LocalizedString.ok,
                                            style: .alert,
                                            completion: { [weak self] in
                                                guard let self = self else { return }
                                                self.deselectAllRows()
                                                self.setAddExercicesButton() })
    }
    
    //MARK: - Publick methods
    func setNavigationTittle(to tittle: String) {
        self.navigationTittle = tittle
    }
    
    func setExercicesList(to list: [Exercise]) {
        self.exercices = list
    }
    
    //MARK: - Actions
    @objc private func addExercicesButtonTouched() {
        self.showAddExerciceAllert()
    }
}

//MARK: - UITableView methods
extension ExercicesListViewControllerOld {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        let exercise = self.exercices[indexPath.row]
        (cell as? DTActivitiesCell)?.renderCellFor(exercise)//setCellFor(exercise)
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let cell = tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
            cell.setSelectedBackgroundColor()
        }
        let exercice = exercices[indexPath.row]
        self.selectedExercices.append(exercice)
        self.setAddExercicesButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
            cell.setUnselectedBackgroundColor()
        }
        self.selectedExercices = self.selectedExercices.filter { (exercice) -> Bool in
            self.exercices[indexPath.row].name != exercice.name
        }
        self.setAddExercicesButton()
    }
}
