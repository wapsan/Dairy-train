import UIKit

final class MuscleGroupsViewController: DTBackgroundedViewController {
    
    //MARK: - Private properties
    private var cellHeight: CGFloat {
        return self.view.bounds.width / 3.5
    }
    
    //MARK: - Properties
    var viewModel: MuscleGroupsViewModel?
    private var trainingEntityTarget: TrainingEntityTarget
    
    //MARK: - GUI Properties
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(ExerciseCell.self, forCellReuseIdentifier: ExerciseCell.cellID)
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
        hideTabBar()
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
        MainCoordinator.shared.dismiss()
    }
}

//MARK: -  UITableViewDataSourse
extension MuscleGroupsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.muscleGroups.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.cellID,
                                                 for: indexPath)
        if let choosenMuscularGroup = self.viewModel?.getChoosenMuscularGroup(by: indexPath.row) {
            (cell as? ExerciseCell)?.renderCellFor(choosenMuscularGroup)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension  MuscleGroupsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.selectRow(at: indexPath.row, with: trainingEntityTarget)
    }
}
