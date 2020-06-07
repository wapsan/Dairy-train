import UIKit

class TrainVC: ActivitiesVC {
    
    //MARK: - GUI Properties
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    //MARK: - Properties
    var exercices: [Exercise] = []
    var trainListVC = TrainsVC()
    var train: Train?
    
    
    private var aproachAlert: DTAproachAlert!
   // var aproachAlert: DTAproachAlert!
   //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpVisualEffectView()
        self.tableView.register(DTExerciceCell.self, forCellReuseIdentifier: DTExerciceCell.cellID)
    }
    
    //MARK: - Private methods
    private func showAproachAlert() {
        self.aproachAlert = .init()
        self.view.addSubview(self.aproachAlert)
        self.aproachAlert.delegate = self
        self.aproachAlert.translatesAutoresizingMaskIntoConstraints = false
        self.activateAproachAllertConstraints()
        self.animateInAlert()
    }
    
    private func showAproachAlert(for exercice: Exercise) {
        self.aproachAlert = .init(for: exercice)
        self.view.addSubview(self.aproachAlert)
        self.aproachAlert.delegate = self
        self.aproachAlert.translatesAutoresizingMaskIntoConstraints = false
        self.activateAproachAllertConstraints()
        self.animateInAlert()
    }
    
    private func animateInAlert() {
        self.aproachAlert.transform = .init(scaleX: 1.3, y: 1.3)
        self.aproachAlert.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.aproachAlert.alpha = 1
            self.aproachAlert.transform = CGAffineTransform.identity
        })
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.aproachAlert.alpha = 0
                        self.aproachAlert.transform = .init(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.aproachAlert.removeFromSuperview()
        }
    }
    
    private func hideAllert() {
        self.animateOutAlert()
        self.deactivateAproachAllertConstraints()
    }
    
    private func setUpVisualEffectView() {
        self.view.addSubview(self.visualEffectView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.visualEffectView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.visualEffectView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.visualEffectView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.visualEffectView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        self.visualEffectView.alpha = 0
    }
    
    //MARK: - Constraints
    private func activateAproachAllertConstraints() {
        NSLayoutConstraint.activate([
            self.aproachAlert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.aproachAlert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -32),
            self.aproachAlert.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            self.aproachAlert.heightAnchor.constraint(equalTo: self.aproachAlert.widthAnchor, multiplier: 0.9)
        ])
    }
    
    
    
    private func deactivateAproachAllertConstraints() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.exercices = self.train!.exercises
        self.tableView.reloadData()
    }
    
    //MARK: - Publick methods
   

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DTExerciceCell.cellID, for: indexPath) as! DTExerciceCell
        let exercice = self.exercices[indexPath.row]
        cell.exerciceNameLabel.text = exercice.name
        cell.muscleGroupImage.image = exercice.muscleSubGroupImage
        cell.exercice = exercice
        cell.addButtonAction = {
            self.showAproachAlert(for: exercice)
           
            //self.showAproachAlert()
            print("Add button touched with closure")
        }
         cell.aproachCollectionList.reloadData()
        
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let safeArea = self.view.safeAreaLayoutGuide.layoutFrame
        return safeArea.height / 3.5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercices.count
    }
    
}

extension TrainVC: DTAproachAlertDelegate {
    func cancelAlertPressed() {
        self.hideAllert()
        
    }
    
    func okAlertPressed() {
        self.hideAllert()
        self.tableView.reloadData()
    }
    
    
}
