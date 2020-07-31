import UIKit

protocol MuscleGroupsViewPresenter: AnyObject {
    func pushSubgroupsViewController(with subgroups: [MuscleSubgroup.Subgroup],
                                     and groups: MuscleGroup.Group)
}

class MuscleGroupsViewController: DTBackgroundedViewController {
    
    //MARK: - Private properties
//    private lazy var muscleGroups = MuscleGroup().groups
    
    var viewModel: MuscleGroupsViewModel!
    
    //MARK: - Properties
    lazy var headerTittle = LocalizedString.selectMuscularGroup
    
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
      //  self.setUpMainView()
    }
    
    //MARK: - Private methods
    private func setUpMainView() {
       // self.view.backgroundColor = .clear
      //  self.setBackgroundImageTo(UIImage.activitiesBackGroundImage)
    }
    
    private func setUpTableView() {
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

//MARK: -  UITableViewDataSourse, UITableViewDelegate
extension MuscleGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.muscleGroups.count//muscleGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        let choosenMuscularGroup = self.viewModel.getChoosenMuscularGroup(by: indexPath.row)//self.muscleGroups[indexPath.row]
        (cell as? DTActivitiesCell)?.renderCellFor(choosenMuscularGroup) //setCellFor(choosenMuscularGroup)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.bounds.width / 3.5
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectRow(at: indexPath.row)
//        let subgroupViewController = MuscleSubgroupsViewController()
//        let muscleGroup = self.viewModel.getChoosenMuscularGroup(by: indexPath.row)//self.muscleGroups[indexPath.row]
//        let muscleGropupList = MuscleSubgroup(for: muscleGroup).listOfSubgroups
//        subgroupViewController.setMuscleSubgroupList(to: muscleGropupList)
//        subgroupViewController.setNavigationTittle(to: muscleGroup.rawValue)
//        self.navigationController?.pushViewController(subgroupViewController, animated: true)
    }
}

extension MuscleGroupsViewController: MuscleGroupsViewPresenter {
    
    func pushSubgroupsViewController(with subgroups: [MuscleSubgroup.Subgroup],
                                     and groups: MuscleGroup.Group) {
        let subgroupViewController = MuscleSubgroupsViewController()
        subgroupViewController.setMuscleSubgroupList(to: subgroups)
        subgroupViewController.setNavigationTittle(to: groups.rawValue)
        self.navigationController?.pushViewController(subgroupViewController, animated: true)
    }
}
