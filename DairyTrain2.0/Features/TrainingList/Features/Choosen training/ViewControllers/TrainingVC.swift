import UIKit

class TrainingVC: MuscleGroupsViewController {

    //MARK: - Properties
 //   var exercices: [Exercise] = []
 //   var trainListVC = TrainsVC()
    var train: TrainingManagedObject?
    
   //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    //   self.setUpNavigationBar()
        self.addObserverForChangingTraining()
       // self.setCurrentTrain()
        self.tableView.register(DTEditingExerciceCell.self, forCellReuseIdentifier: DTEditingExerciceCell.cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
    }
    
    private func setCurrentTrain() {
       // Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
             self.tableView.reloadData()
       // }
    }
    
    private func setUpNavigationBar() {
//        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
//                                         target: self,
//                                         action: #selector(self.editButtonPressed))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.action = #selector(self.editButtonPressed)
    }
    
    private func addObserverForChangingTraining() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainigWasChanged),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
//
    //MARK: - Actions
    @objc private func editButtonPressed() {
        self.tableView.setEditing(self.tableView.isEditing ? false : true, animated: true)
        if self.tableView.isEditing {
            self.editButtonItem.title = "Done"
        } else {
           // NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
            self.editButtonItem.title = "Edit"
        }
    }
//
    @objc private func trainigWasChanged(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let train = userInfo["Train"] as? TrainingManagedObject else { return }
        self.train = train
        self.tableView.reloadData()
        //self.setCurrentTrain()
    }
}

//MARK: - UITableView Datasourse and Delegate
extension TrainingVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DTEditingExerciceCell.cellID,
                                                 for: indexPath)
        guard let train = self.train else { return UITableViewCell() }
        let exercices = CoreDataManager.shared.fetchExercisesFor(train)
        let exercise = exercices[indexPath.row]
        (cell as? DTEditingExerciceCell)?.setUpFor(exercise)
        (cell as? DTEditingExerciceCell)?.addAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            DTCustomAlert.shared.showAproachAlert(on: self, with: exercise, and: nil)
        }
        return cell
    }
     
  
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let safeArea = self.view.safeAreaLayoutGuide.layoutFrame
         return safeArea.height / 3.5
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let train = self.train else { return 0 }
        let exercises = CoreDataManager.shared.fetchExercisesFor(train)
        return exercises.count
     }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let train = self.train else { return }
            //MARK: - TODO проверить удаление ячеек
            let removedExercise = train.exercicesArray[indexPath.row]
            train.removeFromExercises(removedExercise)
            tableView.performBatchUpdates({ //[weak self] in
                tableView.deleteRows(at: [indexPath], with: .top)
                CoreDataManager.shared.removeExercise(removedExercise, from: train)
            }, completion: { _ in
                
            })
        }
    }
   

     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         return true
     }
}

//MARK: - DTCustomAlertDelegate
extension TrainingVC: DTCustomAlertDelegate {
    
    func alertOkPressed() {
        self.tableView.reloadData()
    }
}
