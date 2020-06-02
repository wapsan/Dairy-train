import UIKit


class ActivitiesVC: MainTabBarItemVC {
    
    //MARK: - GUI Properties
    lazy var tableView: UITableView = {
        let table = UITableView()
       // self.tableView = .init(frame: self.view.frame)
        table.delegate = self
        table.dataSource = self
        let nib = UINib(nibName: "DTActivitiesCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: self.activitiesCellId)
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.sectionHeaderHeight = 50
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Private properties
    private var muscleGroups = MuscleGroup().groups
    
    //MARK: - Properties
    var headerTittle = "Select muscle group"
    var activitiesCellId = DTActivitiesCell.cellID
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }
    
    //MARK: - Private methods
    private func setUpTableView() {
        self.view.addSubview(self.tableView)
        self.setTableConstraint()
    }
    
    //MARK: - Constraint
    func setTableConstraint() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

}

//MARK: -  Table view data ourse and delegate
extension ActivitiesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.activitiesCellId, for: indexPath) as! DTActivitiesCell
        let muscleGroup = self.muscleGroups[indexPath.row]
        cell.tittle.text = muscleGroup.rawValue
        cell.muscleGroupImage.image = muscleGroup.image
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = self.tableView.bounds.width
        let height = 100 / 2
        let headerView = DTActivitiesHeaderView(frame: .init(x: 0,
                                                             y: 0,
                                                             width: Int(width),
                                                             height: height))
        headerView.tittle.text = self.headerTittle
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subgroupVC = SubgroupsVC()
        let muscleGroup = self.muscleGroups[indexPath.row]
        let muscleGropupLis = MuscleSubgroup(for: muscleGroup).listOfSubgroups
        subgroupVC.setMuscleSubgroupList(to: muscleGropupLis)
        subgroupVC.setNavigationTittle(to: muscleGroup.rawValue)
        self.navigationController?.pushViewController(subgroupVC, animated: true)
    }
    
}


