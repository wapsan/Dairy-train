import UIKit

class MuscleGroupsViewController: MainTabBarItemVC {
    
    //MARK: - Private properties
    private lazy var muscleGroups = MuscleGroup().groups
    
    //MARK: - Properties
    var headerTittle = LocalizedString.selectMuscularGroup
    
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
        let view = DTHeaderView(title: self.headerTittle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        
        self.view.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [UIColor.red.cgColor, UIColor.viewFlipsideBckgoundColor.cgColor]
           gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
           gradientLayer.cornerRadius = 30
           gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        //   gradientLayer.borderColor = UIColor.red.cgColor
           gradientLayer.borderWidth = 1
           gradientLayer.startPoint = CGPoint(x: 1, y: 0)
           gradientLayer.endPoint = CGPoint(x: 0, y: 1)
           gradientLayer.shadowColor = UIColor.darkGray.cgColor
           gradientLayer.shadowOffset = .init(width: 0, height: 5)
           gradientLayer.shadowOpacity = 5
        self.view.layer.insertSublayer(gradientLayer, at:0)
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
extension MuscleGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        let choosenMuscularGroup = self.muscleGroups[indexPath.row]
        (cell as? DTActivitiesCell)?.setCellFor(choosenMuscularGroup)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subgroupViewController = MuscleSubgroupsViewController()
        let muscleGroup = self.muscleGroups[indexPath.row]
        let muscleGropupList = MuscleSubgroup(for: muscleGroup).listOfSubgroups
        subgroupViewController.setMuscleSubgroupList(to: muscleGropupList)
        subgroupViewController.setNavigationTittle(to: muscleGroup.rawValue)
        self.navigationController?.pushViewController(subgroupViewController, animated: true)
    }
}


