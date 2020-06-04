import UIKit

class ExercicesVC: ActivitiesVC {
    
    //MARK: - Private properties
    private var navigationTittle = ""
    private var exercices: [Exercise] = []
    private var selectedExercices: [Exercise] = []
    
    //MARK: - Properties
    override var headerTittle: String {
        get {
            return "Select exercices"
        }
        set {
            
        }
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
        if self.selectedExercices.isEmpty {
             self.navigationItem.rightBarButtonItem = nil
        } else {
             self.navigationItem.rightBarButtonItem = addButoon
        }
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.title = self.navigationTittle
    }
    
    private func setUpTableView() {
        self.tableView.allowsMultipleSelection = true
    }
    
    private func deselectAllRows() {
        for exercise in self.exercices {
            exercise.isSelected = false
        }
        self.selectedExercices.removeAll()
        self.tableView.reloadData()
    }
    
    private func addExercicesComplition() {
        UserModel.shared.createTrain(with: self.selectedExercices)
        NotificationCenter.default.post(name: .addExercicesToTrain,
                                        object: nil,
                                        userInfo: ["Exercices": UserModel.shared.trains])
        NotificationCenter.default.post(name: .addNewTrain, object: nil)
        self.showAddedAllert()
    }
    
    private func showAddExerciceAllert() {
        AlertHelper.shared.showAllertOn(self,
                                        tittle: nil,
                                        message: "Add this exercice to train?",
                                        cancelTittle: "Cancel",
                                        okTittle: "Ok",
                                        style: .alert,
                                        complition: { self.addExercicesComplition() })
    }
    
    private func showAddedAllert() {
        AlertHelper.shared.showAllertOn(self,
                                        tittle: nil,
                                        message: "Exercices added",
                                        cancelTittle: nil,
                                        okTittle: "Ok",
                                        style: .alert,
                                        complition: { self.deselectAllRows()
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

//MARK: - Table view data sourse and delegate
extension ExercicesVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: super.activitiesCellId) as! DTActivitiesCell
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        
        let exercice = self.exercices[indexPath.row]
        cell.tittle.text = exercice.name
        cell.muscleGroupImage.image = exercice.muscleSubGroupImage
        
        
        if exercice.isSelected {
            cell.cellView.backgroundColor = .red
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            cell.cellView.backgroundColor = .viewFlipsideBckgoundColor
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
