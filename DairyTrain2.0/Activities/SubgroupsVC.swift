import UIKit


class SubgroupsVC: ActivitiesVC {
    
    //MARK: - Private properties
    private var listOfSubgroups: [MuscleSubgroup.Subgroup] = []
    private var navigationTittle: String = ""
    
    //MARK: - Public properties
    override var headerTittle: String {
        get {
            return "Select muscle subgroup"
        }
        set {
            
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.navigationTittle
    }
    
    //MARK: - Publick methods
    func setNavigationTittle(to tittle: String) {
        self.navigationTittle = tittle
    }
    
    func setMuscleSubgroupList(to list: [MuscleSubgroup.Subgroup] ) {
        self.listOfSubgroups = list
    }
    
}

//MARK: - Table view delegate and data sourse
extension SubgroupsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSubgroups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: super.activitiesCellId) as! DTActivitiesCell
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        cell.tittle.text = self.listOfSubgroups[indexPath.row].rawValue
        cell.muscleGroupImage.image = self.listOfSubgroups[indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciceVC = ExercicesVC()
        let subGroup = self.listOfSubgroups[indexPath.row]
        let exercicesList = ExersiceModel.init(for: subGroup).listOfExercices
        exerciceVC.setExercicesList(to: exercicesList)
        exerciceVC.setNavigationTittle(to: subGroup.rawValue)
        self.navigationController?.pushViewController(exerciceVC, animated: true)
    }
    
}
