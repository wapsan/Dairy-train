import UIKit

protocol TrainingViewControllerIteracting: AnyObject {
    func showDeleteTrainingAlert(for trainigAtIndex: Int, with exerciseName: String)
    func updateTraining(with deletingExerciceIndex: Int)
    func hideAproachAlert()
    func deleteLastAproach(inExerciseAt index: Int)
    func addAproach(inExerciseAt index: Int)
    func showChangeAproachAlert(in exerciseIndex: Int, with weight: Float, reps: Int, at aproachIndex: Int)
    func aproachWasChanged(in exersiceIndex: Int, and aptoachIndex: Int)
}

final class TrainingViewController: UIViewController {
    
    //MARK: - Properties
    var viewModel: TrainingViewModel?
    private lazy var aproachAlert = DTNewAproachAlert()
    private var cellHeight: CGFloat {
        return self.view.safeAreaLayoutGuide.layoutFrame.height / 3.5
    }
    
    //MARK: - GUI Properties
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(DTEditingExerciceCell.self,
                       forCellReuseIdentifier: DTEditingExerciceCell.cellID)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var headerView: DTHeaderView = {
        let view = DTHeaderView(title: self.viewModel?.trainingDate ?? "")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTraining()
        self.aproachAlert.delegate = self.viewModel
        self.setUpView()
        self.setUpContraints()
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
        self.view.backgroundColor = DTColors.backgroundColor
        self.navigationItem.title = LocalizedString.training
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.headerView)
    }
    
    func setUpContraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor,
                                                constant: DTEdgeInsets.small.top),
            self.tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.headerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.headerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource
extension TrainingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfExercice ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTEditingExerciceCell.cellID,
                                                 for: indexPath)
        guard let exercise = self.viewModel?.exerciceList[indexPath.row] else { return UITableViewCell() }
        (cell as? DTEditingExerciceCell)?.setUpFor(exercise)
        (cell as? DTEditingExerciceCell)?.addAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            self.aproachAlert.present(on: self, with: exercise.aproachesArray.count, and: indexPath.row)
        }
        (cell as? DTEditingExerciceCell)?.removeAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            self.showDeletenigAproachAlert(forExerciceAt: indexPath.row)
        }
        (cell as? DTEditingExerciceCell)?.changeAproachAction = { [weak self] (aproachIndex, weight, reps) in
             guard let self = self else { return }
             self.viewModel?.aproachWillChanged(in: indexPath.row,
                                                and: aproachIndex)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TrainingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
extension TrainingViewController: TrainingViewControllerIteracting {
    
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
        let indexPath = IndexPath(row: deletingExerciceIndex, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
