import UIKit

class TrainingViewController: MuscleGroupsViewController {
    
    //MARK: - Properties
    private var train: TrainingManagedObject?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObserverForChangingTraining()
        self.setUpTableCell()
        self.addObserverForWeightModeChanged()
        self.setBackgroundImageTo(UIImage.currentTrainbackground)
        self.title = "Train"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Setter
    func setTraining(_ training: TrainingManagedObject) {
        self.train = training
    }
    
    //MARK: - Private methods
    private func addObserverForWeightModeChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.weightModeWasChanged),
                                               name: .weightMetricChanged,
                                               object: nil)
    }
    
    private func setUpTableCell() {
        self.tableView.register(DTEditingExerciceCell.self,
                                forCellReuseIdentifier: DTEditingExerciceCell.cellID)
    }
    
    private func showDeleteLastAproachAlertFor(_ exercice: ExerciseManagedObject) {
        AlertHelper.shared.showDefaultAlert(on: self,
                                            title: "Are you shure",
                                            message: "Delete last aproach?",
                                            cancelTitle: "Cancel",
                                            okTitle: "Ok",
                                            style: .alert,
                                            completion: {
                                                CoreDataManager.shared.removeAproachIn(exercice)
                                                self.tableView.reloadData()
        })
    }
    
    private func setCurrentTrain() {
        self.tableView.reloadData()
    }
    
    private func addObserverForChangingTraining() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainigWasChanged),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    //MARK: - Actions
    @objc private func trainigWasChanged(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let train = userInfo["Train"] as? TrainingManagedObject else { return }
        self.train = train
        self.tableView.reloadData()
    }
    
    @objc func weightModeWasChanged() {
        self.tableView.reloadData()
    }
}

//MARK: - UITableView Datasourse and Delegate
extension TrainingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DTEditingExerciceCell.cellID,
                                                 for: indexPath)
        guard let train = self.train else { return UITableViewCell() }
        let exercise = train.exercicesArray[indexPath.row]
        
        (cell as? DTEditingExerciceCell)?.setUpFor(exercise)
        (cell as? DTEditingExerciceCell)?.addAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            DTCustomAlert.shared.showAproachAlert(on: self, with: exercise, and: nil)
        }
        (cell as? DTEditingExerciceCell)?.removeAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            self.showDeleteLastAproachAlertFor(exercise)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Left it empty 
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.safeAreaLayoutGuide.layoutFrame.height / 3.5
        return height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.train?.exercicesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let train = self.train else { return }
            let removedExercise = train.exercicesArray[indexPath.row]
           train.removeFromExercises(removedExercise)
            tableView.performBatchUpdates({ 
                tableView.deleteRows(at: [indexPath], with: .top)
                CoreDataManager.shared.removeExercise(removedExercise, from: train)
                NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
            }, completion: { _ in
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - DTCustomAlertDelegate
extension TrainingViewController: DTCustomAlertDelegate {
    
    func alertOkPressed() {
        self.tableView.reloadData()
    }
}
