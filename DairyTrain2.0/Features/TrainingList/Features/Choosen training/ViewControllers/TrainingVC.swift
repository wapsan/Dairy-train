import UIKit

class TrainingVC: MuscleGroupsViewController {

    //MARK: - Properties
    var exercices: [Exercise] = []
 //   var trainListVC = TrainsVC()
    var train: Train?
    
   //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.setUpNavigationBar()
        self.addObserverForChangingTraining()
        //self.setCurrentTrain()
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
    
    @objc private func trainigWasChanged(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let train = userInfo["Train"] as? Train else { return }
        self.train = train
        self.tableView.reloadData()
        //self.setCurrentTrain()
    }
}

//MARK: - UITableView Datasourse and Delegate
extension TrainingVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCell(withIdentifier: DTEditingExerciceCell.cellID,
                                                     for: indexPath) as? DTEditingExerciceCell {
           //  let exercice = self.exercices[indexPath.row]
            let exercice = self.train!.exercises[indexPath.row]
             cell.setUpFor(exercice)
             cell.addButtonAction = { [weak self] in
                 guard let self = self else { return }
                 DTCustomAlert.shared.showAproachAlert(on: self, with: exercice, and: nil)
             }
             cell.backgroundColor = .black
             return cell
         } else {
             return UITableViewCell()
         }
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let safeArea = self.view.safeAreaLayoutGuide.layoutFrame
         return safeArea.height / 3.5
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.train!.exercises.count
     }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let deletedExerciceIndex = indexPath.row
//
//           // self.exercices.remove(at: deletedExerciceIndex)
//           // NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
//            self.tableView.performBatchUpdates({
//                self.train!.exercises.remove(at: deletedExerciceIndex)
//                self.tableView.deleteRows(at: [indexPath], with: .left)
//
//            }) { ( _ ) in
//                //сохранение данных
//            }
//        } else if editingStyle == .insert {
//            self.tableView.reloadData()
//        }
//    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//      //  self.exercices.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//        self.train!.exercises.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//        print("From \(sourceIndexPath.row)")
//        print("To \(destinationIndexPath.row)")
//       // NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
//    }
//    //Настройка кастомного редактирования таблицы
////    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
////    }
//
//     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//         return true
//     }
//
//     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//         return true
//     }
}

//MARK: - DTCustomAlertDelegate
extension TrainingVC: DTCustomAlertDelegate {
    
    func alertOkPressed() {
        self.tableView.reloadData()
    }
}
