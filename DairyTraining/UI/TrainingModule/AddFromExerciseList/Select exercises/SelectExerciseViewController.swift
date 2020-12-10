import UIKit

protocol  SelectExerciseViewIteractor: AnyObject {
    func muscularSubgroupWasChanged()
    func updateAddButtonState(to isActive: Bool)
    func exerciseWasAdded()
}

final class SelectExerciseViewController: MainTabBarItemVC {
    
    //MARK: - @IBOutlets
    @IBOutlet var subgroupSegmentControll: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    private var viewModel: SelectExerciseViewModelOutput
    private var currentSegmentIndex: Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: SelectExerciseViewModelOutput) {
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
private extension SelectExerciseViewController {

    func setupTableView() {
        tableView.register(ExerciseCell.self,
                           forCellReuseIdentifier: ExerciseCell.cellID)
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
                                                  animated: false)
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
extension SelectExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.cellID,
                                                 for: indexPath)
        (cell as? ExerciseCell)?.renderCellFor(viewModel.exerciseList[indexPath.row])
        if viewModel.selectedExercise.contains(viewModel.exerciseList[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            (cell as? ExerciseCell)?.setSelectedBackgroundColor()
            return cell
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            (cell as? ExerciseCell)?.setUnselectedBackgroundColor()
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension SelectExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.exerciseWasSelected(at: indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) as? ExerciseCell else { return }
        cell.setSelectedBackgroundColor()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.viewModel.exerciseWasDeselected(at: indexPath.row)
        guard let cell = tableView.cellForRow(at: indexPath) as? ExerciseCell else { return }
        cell.setUnselectedBackgroundColor()
    }
}

//MARK: - SelectExerciseNewViewControllerIteractor
extension SelectExerciseViewController: SelectExerciseViewIteractor {
    
    func exerciseWasAdded() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateAddButtonState(to isActive: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isActive
    }
    
    func muscularSubgroupWasChanged() {
        if currentSegmentIndex > subgroupSegmentControll.selectedSegmentIndex {
            tableView.reloadSections(IndexSet(integer: 0), with: .right)
        } else {
            tableView.reloadSections(IndexSet(integer: 0), with: .left)
        }
        currentSegmentIndex = subgroupSegmentControll.selectedSegmentIndex
        
    }
}
