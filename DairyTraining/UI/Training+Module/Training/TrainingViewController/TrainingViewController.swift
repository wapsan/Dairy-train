import UIKit

protocol TrainingView: AnyObject {
    func showDeleteTrainingAlert(for trainigAtIndex: Int, with exerciseName: String)
    func updateTraining(with deletingExerciceIndex: Int)
    func hideAproachAlert()
    func deleteLastAproach(inExerciseAt index: Int)
    func addAproach(inExerciseAt index: Int)
    func showChangeAproachAlert(in exerciseIndex: Int, with weight: Float, reps: Int, at aproachIndex: Int)
    func aproachWasChanged(in exersiceIndex: Int, and aptoachIndex: Int)
    func trainingWasChanged()
    func markCellAsDone(at index: Int)
    func showAlertForDoneExercise()
}

final class TrainingViewController: UIViewController {


    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Module property
    var viewModel: TrainingViewModeProtocol?
    
    private lazy var aproachAlert = DTNewAproachAlert()
    
    private var cellHeight: CGFloat {
        return self.view.safeAreaLayoutGuide.layoutFrame.height / 3.5
    }

    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
        MainCoordinator.shared.setTabBarHidden(true, duration: 0.25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTraining()
        aproachAlert.delegate = viewModel as? NewAproachAlertDelegate
        setUpView()
    }
}

//MARK: - Private extension
private extension TrainingViewController {
    
    func showDeletenigAproachAlert(forExerciceAt index: Int) {
        self.showDefaultAlert(message: LocalizedString.deleteLastAproach,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok,
                              cancelTitle: LocalizedString.cancel,
                              completion: { [weak self] in
                                self?.viewModel?.removeLatsAproach(at: index)
        })
    }
    
    func loadTraining() {
        self.viewModel?.loadTrain()
    }
    
    func setUpView() {
        tableView.register(DTEditingExerciceCell.self,
                               forCellReuseIdentifier: DTEditingExerciceCell.cellID)
        self.view.backgroundColor = DTColors.backgroundColor
        self.navigationItem.title = LocalizedString.training
    }
}

//MARK: - UITableViewDataSource
extension TrainingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.exerciseCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTEditingExerciceCell.cellID,
                                                 for: indexPath)
        guard let exercise = self.viewModel?.exerciseList[indexPath.row] else { return UITableViewCell() }
        (cell as? DTEditingExerciceCell)?.setUpFor(exercise)
        (cell as? DTEditingExerciceCell)?.addAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            self.aproachAlert.present(on: self, with: exercise.aproachesArray.count, and: indexPath.row)
        }
        (cell as? DTEditingExerciceCell)?.removeAproachButtonAction = { [weak self] in
            self?.showDeletenigAproachAlert(forExerciceAt: indexPath.row)
        }
        (cell as? DTEditingExerciceCell)?.changeAproachAction = { [weak self] (aproachIndex, weight, reps) in
             self?.viewModel?.aproachWillChanged(in: indexPath.row, and: aproachIndex)
        }
        (cell as? DTEditingExerciceCell)?.doneButtonPressedAction = { [weak self] in
            self?.viewModel?.exerciseDone(at: indexPath.row)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TrainingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TrainingPaternsHeaderView.view()
        view?.tittle.text = viewModel?.trainingDate
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [weak self] in
                self?.viewModel?.showStatisticsForExercise(at: indexPath.row)
                }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "info")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !((tableView.cellForRow(at: indexPath) as? DTEditingExerciceCell)?.isDone ?? false) else { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [weak self] in
                self?.viewModel?.tryDeleteExercice(at: indexPath.row)
                }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - TestTrainingViewControllerIteracting
extension TrainingViewController: TrainingView {
    
    func showAlertForDoneExercise() {
        showDefaultAlert(title: "Finish this exercise?",
                         message: "Are you sure?",
                         preffedStyle: .alert,
                         okTitle: LocalizedString.ok,
                         cancelTitle: LocalizedString.cancel,
                         completion: { [weak self] in
                            self?.viewModel?.doneExercise()
                         })
    }
    
    func markCellAsDone(at index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DTEditingExerciceCell
        cell?.markAsDone(isDone: true)
    }
 
    func trainingWasChanged() {
        self.tableView.reloadData()
    }
    
    func showChangeAproachAlert(in exerciseIndex: Int, with weight: Float, reps: Int, at aproachIndex: Int) {
        self.aproachAlert.present(on: self,
                                     for: aproachIndex,
                                     and: exerciseIndex,
                                     weight: weight,
                                     reps: reps)
    }

    func aproachWasChanged(in exersiceIndex: Int, and aptoachIndex: Int) {
        let indexPath = IndexPath(row: exersiceIndex, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath) as? DTEditingExerciceCell {
            cell.changeAproach(at: aptoachIndex)
        }
    }
    
    func addAproach(inExerciseAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath) as? DTEditingExerciceCell {
            cell.addAproach()
        }
    }
    
    func deleteLastAproach(inExerciseAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath) as? DTEditingExerciceCell {
            cell.removeLastAproach()
        }
    }
    
    func hideAproachAlert() {
        self.aproachAlert.hideAlert()
    }
    
    func showDeleteTrainingAlert(for trainigAtIndex: Int, with exerciseName: String) {
        let localizedExerciceName = NSLocalizedString(exerciseName, comment: "")
        let alertmassege = String(format: NSLocalizedString("Delete exercise from trainig?",
                                                            comment: ""), localizedExerciceName)
        self.showDefaultAlert(message: alertmassege,
                              preffedStyle: .alert,
                              okTitle: LocalizedString.ok,
                              cancelTitle: LocalizedString.cancel) { [weak self] in
                                self?.viewModel?.deleteExercice(at: trainigAtIndex)
        }
    }
    
    func updateTraining(with deletingExerciceIndex: Int) {
        tableView.deleteRows(at: [IndexPath(row: deletingExerciceIndex, section: 0)], with: .fade)
        tableView.reloadData()
    }
}
