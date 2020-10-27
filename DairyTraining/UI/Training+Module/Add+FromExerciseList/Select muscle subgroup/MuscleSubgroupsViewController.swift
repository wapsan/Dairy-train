import UIKit

protocol MuscleSubgroupsViewPresenter: AnyObject {
    func pushExerciseList(with exerciseList: [Exercise], and subgroupTitle: String)
}

final class MuscleSubgroupsViewController: UIViewController {
    
    //MARK: - Private properties
    private var cellHeight: CGFloat {
        return self.view.bounds.width / 3.5
    }
    
    //MARK: - Properties
    var viewModel: MuscleSubgropsViewModel?
    var router: MuscleSubgropsRouter?
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
        let view = DTHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
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
}

//MARK: - Public extension
private extension MuscleSubgroupsViewController {
    
    func setup() {
        self.setUpTableView()
        self.view.backgroundColor = DTColors.backgroundColor
        self.title = self.viewModel?.groupTitle
        self.headerView.setTitle(to: LocalizedString.selectMuscularSubgroup)
    }
    
    func setUpTableView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.headerView)
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
}

//MARK: - UITableViewDelegate
extension MuscleSubgroupsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.selectRow(at: indexPath.row)
    }
}

//MARK: - UITableViewDataSource
extension MuscleSubgroupsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.subgroupList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        guard let subgroup = self.viewModel?.subgroupList[indexPath.row] else { return UITableViewCell() }
        (cell as? DTActivitiesCell)?.renderCellFor(subgroup)
        return cell
    }
}

//MARK: - MuscleSubgroupsViewPresenter
extension MuscleSubgroupsViewController: MuscleSubgroupsViewPresenter {
    
    func pushExerciseList(with exerciseList: [Exercise], and subgroupTitle: String) {
        self.router?.pushExerciseListViewController(with: exerciseList,
                                                    and: subgroupTitle,
                                                    target: trainingEntityTarget)
    }
}
