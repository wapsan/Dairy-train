import UIKit

class TrainVC: ActivitiesVC {

    //MARK: - Properties
    var exercices: [Exercise] = []
    var trainListVC = TrainsVC()
    var train: Train?
    
   //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DTExerciceCell.self, forCellReuseIdentifier: DTExerciceCell.cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.exercices = self.train!.exercises
        self.tableView.reloadData()
    }
    
    //MARK: - Tableview methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DTExerciceCell.cellID,
                                                    for: indexPath) as? DTExerciceCell {
            let exercice = self.exercices[indexPath.row]
            cell.setUpFor(exercice)
            cell.addButtonAction = { [weak self] in
                guard let self = self else { return }
                DTCustomAlert.shared.showAproachAlert(on: self, with: exercice, and: nil)
            }
            cell.backgroundColor = .black
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let safeArea = self.view.safeAreaLayoutGuide.layoutFrame
        return safeArea.height / 3.5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercices.count
    }
}

extension TrainVC: DTCustomAlertDelegate {
    
    func alertOkPressed() {
        self.tableView.reloadData()
    }
}
