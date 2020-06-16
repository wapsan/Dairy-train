import UIKit

class MuscleGroupsVC: MainTabBarItemVC {
    
    //MARK: - Private properties
    private var muscleGroups = MuscleGroup().groups
    
    //MARK: - Properties
    var headerTittle = "Select muscle group"
    
    //MARK: - GUI Properties
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(DTActivitiesCell.self, forCellReuseIdentifier: DTActivitiesCell.cellID)
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var headerView: DTHeaderView = {
        let view = DTHeaderView(title: self.headerTittle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }
    
    //MARK: - Private methods
    private func setUpTableView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.headerView)
        self.setTableConstraints()
    }
    
    //MARK: - Constraint
    func setTableConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 8),
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

//MARK: -  UITableViewDataSourse, UITableViewDelegate
extension MuscleGroupsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath) as! DTActivitiesCell
        let muscleGroup = self.muscleGroups[indexPath.row]
        cell.exerciceNameLabel.text = muscleGroup.rawValue
        cell.muscleGroupImage.image = muscleGroup.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subgroupVC = MuscleSubgroupsVC()
        let muscleGroup = self.muscleGroups[indexPath.row]
        let muscleGropupList = MuscleSubgroup(for: muscleGroup).listOfSubgroups
        subgroupVC.setMuscleSubgroupList(to: muscleGropupList)
        subgroupVC.setNavigationTittle(to: muscleGroup.rawValue)
        self.navigationController?.pushViewController(subgroupVC, animated: true)
    }
}


