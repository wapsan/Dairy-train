import UIKit

protocol ExerciseListViewPresenter: AnyObject {
    func updateAddButton(isActive: Bool)
}

final class ExerciseListViewControllerNew: UIViewController {
    
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
        table.register(DTActivitiesCell.self, forCellReuseIdentifier: DTActivitiesCell.cellID)
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
private extension ExerciseListViewControllerNew {
    
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
    
    func setAddExercicesButton(to active: Bool) {
        let addButoon = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.addExercicesButtonTouched))
        self.navigationItem.rightBarButtonItem = active ? addButoon : nil
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
    
    //MARK: - Actions
    @objc private func addExercicesButtonTouched() {
       //FIXME: Finish with bussines logic of thiw module
    }
}

//MARK: - UITableViewDataSource
extension ExerciseListViewControllerNew: UITableViewDataSource {
    
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
extension ExerciseListViewControllerNew: UITableViewDelegate {
    
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

extension ExerciseListViewControllerNew: ExerciseListViewPresenter {
    
    func updateAddButton(isActive: Bool) {
        self.setAddExercicesButton(to: !isActive)
    }
}
