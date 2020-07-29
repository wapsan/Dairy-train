import UIKit

class MuscleSubgroupsViewController: MuscleGroupsViewController {
    
    //MARK: - Private properties
    private lazy var listOfSubgroups: [MuscleSubgroup.Subgroup] = []
    private lazy var navigationTittle: String = ""
    
    //MARK: - Public properties
    override var headerTittle: String {
        get {
            return LocalizedString.selectMuscularSubgroup
        }
        set { }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.navigationTittle
    }
    
    //MARK: - Setters
    func setNavigationTittle(to tittle: String) {
        self.navigationTittle = NSLocalizedString(tittle, comment: "")
    }
    
    func setMuscleSubgroupList(to list: [MuscleSubgroup.Subgroup] ) {
        self.listOfSubgroups = list
    }
}

//MARK: - Table view delegate and data sourse
extension MuscleSubgroupsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSubgroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DTActivitiesCell.cellID,
                                                 for: indexPath)
        let choosenMuscularSubgroups = self.listOfSubgroups[indexPath.row]
        (cell as? DTActivitiesCell)?.renderCellFor(choosenMuscularSubgroups) //setCellFor(choosenMuscularSubgroups)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciceVC = ExercicesViewController()
        let subGroup = self.listOfSubgroups[indexPath.row]
        let exercicesList = ExersiceModel.init(for: subGroup).listOfExercices
        exerciceVC.setExercicesList(to: exercicesList)
        exerciceVC.setNavigationTittle(to: subGroup.rawValue)
        self.navigationController?.pushViewController(exerciceVC, animated: true)
    }
}
