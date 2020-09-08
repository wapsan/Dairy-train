import UIKit

protocol ExerciseListViewPresenter: AnyObject {
    func updateAddButton(isActive: Bool)
    func apdateUIAfterExerciseAdding()
}

final class ExerciseListViewController: UIViewController {
    
    //MARK: - Module propertie
    var viewModel: ExerciseListViewModel?
    
    //MARK: - Private properties
     private var cellHeight: CGFloat {
         return self.view.bounds.width / 3.5
     }
    
    //MARK: - GUI Properties
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(DTActivitiesCell.self,
                       forCellReuseIdentifier: DTActivitiesCell.cellID)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsMultipleSelection = true
        return table
    }()
    
    private lazy var headerView: DTHeaderView = {
        let view = DTHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

//MARK: - Public extension
private extension ExerciseListViewController {
    
    func setup() {
        self.setUpTableView()
        self.view.backgroundColor = DTColors.backgroundColor
        self.title = self.viewModel?.subgroupTitle
        self.headerView.setTitle(to: LocalizedString.selectMuscularSubgroup)
    }
    
    func setUpTableView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.headerView)
        self.setTableConstraints()
    }
    
    func setAddExercicesButton(isActive: Bool) {
        let addButoon = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.addExercicesButtonTouched))
        self.navigationItem.rightBarButtonItem = isActive ? addButoon : nil
    }
    
    //MARK: - Constraints
    func setTableConstraints() {
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
    
    func deselectAllRows() {
        guard let indexPaths = self.tableView.indexPathsForSelectedRows else { return }
        for indexPath in indexPaths {
            if let cell = self.tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
                cell.setUnselectedBackgroundColor()
            }
        }
    }
    
    func showAddExerciceAllert() {
        AlertHelper.shared.showDefaultAlert(
            on: self,
            title: nil,
            message: LocalizedString.alertAddThisExercisesToTrain,
            cancelTitle: LocalizedString.cancel,
            okTitle: LocalizedString.ok,
            style: .alert,
            completion: { [weak self] in
                self?.addExerciseAlertCompletion()
            })
    }
    
    func addExerciseAlertCompletion() {
        self.viewModel?.writeExerciseToTraining()
    }
    
    func showExerciseWasAddedAlert() {
        AlertHelper.shared.showDefaultAlert(
            on: self,
            title: nil,
            message: LocalizedString.exercisesAdded,
            cancelTitle: nil,
            okTitle: LocalizedString.ok,
            style: .alert,
            completion: nil)
    }
    
    //MARK: - Actions
    @objc private func addExercicesButtonTouched() {
        self.showAddExerciceAllert()
    }
}

//MARK: - UITableViewDataSource
extension ExerciseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.exerciseList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        guard let exercise = self.viewModel?.exerciseList[indexPath.row] else { return UITableViewCell() }
        (cell as? DTActivitiesCell)?.renderCellFor(exercise)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ExerciseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.exerciseWasSelected(at: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
            cell.setSelectedBackgroundColor()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.viewModel?.exerciseWasDeselect(at: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? DTActivitiesCell {
            cell.setUnselectedBackgroundColor()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
}

//MARK: - ExerciseListViewPresenter
extension ExerciseListViewController: ExerciseListViewPresenter {
    
    func apdateUIAfterExerciseAdding() {
        self.deselectAllRows()
        self.setAddExercicesButton(isActive: false)
        self.showExerciseWasAddedAlert()
    }
    
    func updateAddButton(isActive: Bool) {
        self.setAddExercicesButton(isActive: !isActive)
    }
}
