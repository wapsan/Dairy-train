import UIKit

protocol TrainingView: AnyObject {
    func showDeleteTrainingAlert(for trainigAtIndex: Int, with exerciseName: String)
    func deleteCell(at index: Int)
    func hideAproachAlert()
    func deleteLastAproach(inExerciseAt index: Int)
    func addAproach(inExerciseAt index: Int)
    func showChangeAproachAlert(in exerciseIndex: Int, with weight: Float, reps: Int, at aproachIndex: Int)
    func aproachWasChanged(in exersiceIndex: Int, and aptoachIndex: Int)
    func reloadTable()
    func reloadCell(at index: Int)
    func showAlertForDoneExercise()
}

final class TrainingViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - GUI Properties
    private var stratchabelHeader: StretchableHeader?
    
    //MARK: - Module property
    private var viewModel: TrainingViewModeProtocol
    private lazy var aproachAlert = DTNewAproachAlert()
    
    private var cellHeight: CGFloat {
        return self.view.safeAreaLayoutGuide.layoutFrame.height / 3.5
    }

    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Initialization
    init(viewModel: TrainingViewModeProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension
private extension TrainingViewController {
    
    func showDeletenigAproachAlert(forExerciceAt index: Int) {
        showDefaultAlert(
            message: LocalizedString.deleteLastAproach,
            preffedStyle: .alert,
            okTitle: LocalizedString.ok,
            cancelTitle: LocalizedString.cancel,
            completion: { [weak self] in
                self?.viewModel.removeLatsAproach(at: index)
            })
    }
    
    func loadTraining() {
        viewModel.loadTrain()
    }
    
    func setup() {
        loadTraining()
        aproachAlert.delegate = viewModel as? NewAproachAlertDelegate
        tableView.register(DTEditingExerciceCell.self, forCellReuseIdentifier: DTEditingExerciceCell.cellID)
        setupHeaders()
    }
    
    private func setupHeaders() {
        let headerSize = CGSize(width: tableView.frame.size.width, height: 150)
        stratchabelHeader = StretchableHeader(frame: CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height))
        stratchabelHeader?.title = viewModel.trainingDate
        stratchabelHeader?.customDescription = nil
        stratchabelHeader?.backButtonImageType = .goBack
        stratchabelHeader?.onBackButtonAction = { [unowned self] in self.viewModel.backButtonPressed() }
        stratchabelHeader?.setTopRightButton(image: UIImage(named: "icon_home_menu"))
        stratchabelHeader?.topRightButtonAction = { [unowned self] in self.viewModel.statisticsButtonPressed() }
        stratchabelHeader?.backgroundColor = .black
        stratchabelHeader?.minimumContentHeight = 44
        guard let header = stratchabelHeader else { return }
        tableView.addSubview(header)
    }
}


//MARK: - UITableViewDataSource
extension TrainingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exerciseCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTEditingExerciceCell.cellID,
                                                 for: indexPath)
         let exercise = self.viewModel.exerciseList[indexPath.row]
        (cell as? DTEditingExerciceCell)?.setUpFor(exercise)
        (cell as? DTEditingExerciceCell)?.addAproachButtonAction = { [weak self] in
            guard let self = self else { return }
            self.aproachAlert.present(on: self, with: exercise.aproachesArray.count, and: indexPath.row)
        }
        (cell as? DTEditingExerciceCell)?.removeAproachButtonAction = { [weak self] in
            self?.showDeletenigAproachAlert(forExerciceAt: indexPath.row)
        }
        (cell as? DTEditingExerciceCell)?.changeAproachAction = { [weak self] (aproachIndex, weight, reps) in
             self?.viewModel.aproachWillChanged(in: indexPath.row, and: aproachIndex)
        }
        (cell as? DTEditingExerciceCell)?.doneButtonPressedAction = { [weak self] in
            self?.viewModel.exerciseDone(at: indexPath.row)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TrainingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = TrainingTableFooterView.view()
        footer?.isActive = viewModel.isTrainingEditable
        footer?.onAction = { [unowned self] in self.viewModel.footerButtonPressed() }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Files") { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [weak self] in
                self?.viewModel.showStatisticsForExercise(at: indexPath.row)
                }, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "checkmark_training")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard viewModel.isExerciseEditable(at: indexPath.row) && viewModel.isTrainingEditable else { return nil }
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            tableView.performBatchUpdates({ [weak self] in
                self?.viewModel.tryDeleteExercice(at: indexPath.row)
            }, completion: nil)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = DTColors.backgroundColor
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - TestTrainingViewControllerIteracting
extension TrainingViewController: TrainingView {

    func deleteCell(at index: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    func showAlertForDoneExercise() {
        showDefaultAlert(title: "Finish this exercise?",
                         message: "Are you sure?",
                         preffedStyle: .alert,
                         okTitle: LocalizedString.ok,
                         cancelTitle: LocalizedString.cancel,
                         completion: { [weak self] in
                            self?.viewModel.doneExercise()
                         })
    }
    
    func reloadCell(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
 
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showChangeAproachAlert(in exerciseIndex: Int, with weight: Float, reps: Int, at aproachIndex: Int) {
        aproachAlert.present(on: self,
                             for: aproachIndex,
                             and: exerciseIndex,
                             weight: weight,
                             reps: reps)
    }

    func aproachWasChanged(in exersiceIndex: Int, and aptoachIndex: Int) {
        let cell = self.tableView.cellForRow(at:  IndexPath(row: exersiceIndex, section: 0)) as? DTEditingExerciceCell
        cell?.changeAproach(at: aptoachIndex)
    }
    
    func addAproach(inExerciseAt index: Int) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DTEditingExerciceCell
        cell?.addAproach()
    }
    
    func deleteLastAproach(inExerciseAt index: Int) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DTEditingExerciceCell
        cell?.removeLastAproach()
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
                                self?.viewModel.deleteExercice(at: trainigAtIndex)
        }
    }
}
