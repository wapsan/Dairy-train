import UIKit

protocol MuscleGroupsViewPresenter: AnyObject {
    func pushSubgroupsViewController(with subgroups: [MuscleSubgroup.Subgroup],
                                     and groups: MuscleGroup.Group)
}


final class MuscleGroupsViewController: DTBackgroundedViewController {
    
    //MARK: - Private properties
    private var cellHeight: CGFloat {
        return self.view.bounds.width / 3.5
    }
    
    //MARK: - Properties
    var viewModel: MuscleGroupsViewModel?
    var router: MuscleGroupsRouter?
    private var trainingEntityTarget: TrainingEntityTarget
    
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
        return table
    }()
    
    private lazy var headerView: DTHeaderView = {
        let view = DTHeaderView(title: LocalizedString.selectMuscularGroup)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        //FIXME: - Finish setup hiden tab bar 
        self.extendedLayoutIncludesOpaqueBars = true
        self.setTabBarHidden(true, animated: true, duration: 0.25)
    }
    
    //MARK: - Initialization
    init(trainingEntityTarget: TrainingEntityTarget) {
        self.trainingEntityTarget = trainingEntityTarget
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setUpTableView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.headerView)
        let backBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backBarButton
        self.setTableConstraints()
    }
    
    //MARK: - Constraint
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
    
    // MARK: - Actions
    @objc private func backAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: -  UITableViewDataSourse, UITableViewDelegate
extension MuscleGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.muscleGroups.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        if let choosenMuscularGroup = self.viewModel?.getChoosenMuscularGroup(by: indexPath.row) {
            (cell as? DTActivitiesCell)?.renderCellFor(choosenMuscularGroup)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.selectRow(at: indexPath.row)
    }
}

//MARK: - MuscleGroupsViewPresenter
extension MuscleGroupsViewController: MuscleGroupsViewPresenter {
    
    func pushSubgroupsViewController(with subgroups: [MuscleSubgroup.Subgroup],
                                     and groups: MuscleGroup.Group) {
        self.router?.pushMuscleSubgroupsGroupViewController(with: subgroups,
                                                            and: groups.name,
                                                            target: trainingEntityTarget)
    }
}
