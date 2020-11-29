import UIKit

protocol  SelectExerciseNewViewControllerIteractor: AnyObject {
    func muscularSubgroupWasChanged()
    func updateAddButtonState(to isActive: Bool)
    func exerciseWasAdded()
}

final class SelectExerciseNewViewController: MainTabBarItemVC {
    
    //MARK: - @IBOutlets
    @IBOutlet var subgroupSegmentControll: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    private var viewModel: SelectExerciseNewViewModelOutput
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: SelectExerciseNewViewModelOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setup() {
        setupTableView()
        setupMuscularSubgroupSegmentControll()
        setupNavigationBar()
    }
    
    //MARK: - Actions
    @IBAction func subgroupChangeAction(_ sender: UISegmentedControl) {
        viewModel.muscularSubgtoupWacChanged(to: sender.selectedSegmentIndex)
    }
    
    @objc private func addButtonAction() {
        showAddExerciseAllert()
    }
}
 
//MARK: - Private extension
private extension SelectExerciseNewViewController {

    func setupTableView() {
        tableView.register(DTActivitiesCell.self,
                           forCellReuseIdentifier: DTActivitiesCell.cellID)
    }
    
    func setupNavigationBar() {
        title = viewModel.muscularGroupName
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                 target: self,
                                                 action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupMuscularSubgroupSegmentControll() {
        subgroupSegmentControll.removeAllSegments()
        viewModel.muscularSubgroupsTitles.forEach({
            subgroupSegmentControll.insertSegment(withTitle: $0,
                                                  at: viewModel.muscularSubgroupsTitles.count,
                                                  animated: true)
        })
        subgroupSegmentControll.selectedSegmentIndex = 0
        viewModel.muscularSubgtoupWacChanged(to: 0)
    }
    
    func showAddExerciseAllert() {
        let alertTitle = viewModel.selectedExercise.count > 1 ?
        "Add exercises to training" : "Add exercise to training"
        showDefaultAlert(title: alertTitle,
                         message: nil,
                         preffedStyle: .alert,
                         okTitle: LocalizedString.ok,
                         cancelTitle: LocalizedString.cancel,
                         completion: addExerciseAlertCompletion)
    }
    
    func addExerciseAlertCompletion() {
        viewModel.addSelectesExercisesToTraining()
    }
}

//MARK: - UITableViewDataSource
extension SelectExerciseNewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        (cell as? DTActivitiesCell)?.renderCellFor(viewModel.exerciseList[indexPath.row])
        if viewModel.selectedExercise.contains(viewModel.exerciseList[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            (cell as? DTActivitiesCell)?.setSelectedBackgroundColor()
            return cell
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            (cell as? DTActivitiesCell)?.setUnselectedBackgroundColor()
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension SelectExerciseNewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.exerciseWasSelected(at: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
            cell.setSelectedBackgroundColor()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.viewModel.exerciseWasDeselected(at: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
            cell.setUnselectedBackgroundColor()
        }
    }
}

//MARK: - SelectExerciseNewViewControllerIteractor
extension SelectExerciseNewViewController: SelectExerciseNewViewControllerIteractor {
    
    func exerciseWasAdded() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateAddButtonState(to isActive: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isActive
    }
    
    func muscularSubgroupWasChanged() {
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
}
