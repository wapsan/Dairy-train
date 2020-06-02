import UIKit

class TrainVC: ActivitiesVC {
    
    //MARK: - Properties
    var exercices: [Exercise] = []
    var trainListVC = TrainsVC()
    var train: Train?
    
   // var aproachAlert: DTAproachAlert!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DTExerciceCell.self, forCellReuseIdentifier: DTExerciceCell.cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.exercices = self.train!.exercises
        self.tableView.reloadData()
    }
    
    //MARK: - Publick methods
    func showAproachAlert() {
        let alert =  DTAproachAlert(on: self.view)
        self.view.addSubview(alert)
        alert.show(on: self.view)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DTExerciceCell.cellID, for: indexPath) as! DTExerciceCell
        let exercice = self.exercices[indexPath.row]
        cell.exerciceNameLabel.text = exercice.name
        cell.muscleGroupImage.image = exercice.muscleSubGroupImage
        cell.exercice = exercice
        cell.addButtonAction = {
            self.showAproachAlert()
            print("Add button touched with closure")
        }
        cell.backgroundColor = .black
        return cell

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let safeArea = self.view.safeAreaLayoutGuide.layoutFrame
        return safeArea.height / 3.5
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercices.count
    }
    
    
    
    
    
    
    
    
}
