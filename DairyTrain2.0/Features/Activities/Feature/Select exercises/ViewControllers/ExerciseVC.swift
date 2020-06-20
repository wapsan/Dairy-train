import UIKit

class ExercicesViewController: MuscleGroupsViewController {
    
    //MARK: - Private properties
    private lazy var navigationTittle = ""
    private lazy var exercices: [Exercise] = []
    private lazy var selectedExercices: [Exercise] = []
    
    //MARK: - Properties
    override var headerTittle: String {
        get {
            return LocalizedString.selectExercises
        }
        set {}
    }
    
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
        self.navigationItem.title = self.navigationTittle
    }
    
    private func setUpTableView() {
        self.tableView.allowsMultipleSelection = true
    }
    
    private func deselectAllRows() {
        self.exercices.forEach({ $0.isSelected = false })
        self.selectedExercices.removeAll()
        self.tableView.reloadData()
    }
    
    private func addExercicesComplition() {
        if UserTrainingModelFileManager.shared.addExercesToTrain(self.selectedExercices) {
            NotificationCenter.default.post(name: .addNewTrain,
                                            object: nil,
                                            userInfo: ["Trains": UserModel.shared.trains] )
        } else {
            NotificationCenter.default.post(name: .trainingWasChanged,
                                            object: nil,
                                            userInfo: ["Train": UserTrainingModelFileManager.shared.trainingInfo.trainingList[0]])
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
                                            completion: { self.addExercicesComplition() })
    }
    
    private func showAddedAllert() {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: nil,
                                            message: LocalizedString.exercisesAdded,
                                            cancelTitle: nil,
                                            okTitle: LocalizedString.ok,
                                            style: .alert,
                                            completion: { self.deselectAllRows()
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
extension ExercicesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        let choosenExercice = self.exercices[indexPath.row]
        (cell as? DTActivitiesCell)?.setCellFor(choosenExercice)
        
        if choosenExercice.isSelected {
            (cell as? DTActivitiesCell)?.setBackroundColorTo(.red)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            (cell as? DTActivitiesCell)?.setBackroundColorTo(.viewFlipsideBckgoundColor)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.exercices[indexPath.row].isSelected = true
        let exercice = exercices[indexPath.row]
        self.selectedExercices.append(exercice)
        self.setAddExercicesButton()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.exercices[indexPath.row].isSelected = false
        self.selectedExercices = self.selectedExercices.filter { (exercice) -> Bool in
            self.exercices[indexPath.row].name != exercice.name
        }
        self.setAddExercicesButton()
        self.tableView.reloadData()
    }
}
