import UIKit

fileprivate enum CreateTrainingOptionsModel: String, CaseIterable {
    case fromExerciseList = "Exercise"
    case fromTrainingPatern = "Paterns"
    case fromSpecialTraining = "Special training"
    
    var title: String {
        return self.rawValue
    }
    
    var image: UIImage? {
        switch self {
        case .fromExerciseList:
            return UIImage(named: "avareProjectileWeightBackground")
        case .fromTrainingPatern:
            return UIImage(named: "avareProjectileWeightBackground")
        case .fromSpecialTraining:
            return UIImage(named: "avareProjectileWeightBackground")
        }
    }
    
    func onAction() {
        switch self {
        case .fromExerciseList:
            MainCoordinator.shared.coordinate(to: MuscleGroupsCoordinator.Target.muscularGrops(patern: .training))
        case .fromTrainingPatern:
            MainCoordinator.shared.coordinate(to: TrainingPaternsCoordinator.Target.trainingPaternsList)
        case .fromSpecialTraining:
            MainCoordinator.shared.coordinate(to: TrainingProgramsCoordinator.Target.trainingLevels)
        }
    }
}

final class CreteTrainingModalViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var decorateView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var containerView: UIView!
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        decorateView.layer.cornerRadius = decorateView.bounds.height / 2
    }
    
    // MARK: - Setter
    private func setup() {
        tableView.register(cell: PopUpOptionCell.self)
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - Actions
    @IBAction func backgroundViewTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CreteTrainingModalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateTrainingOptionsModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopUpOptionCell.cellID, for: indexPath)
        let popUpMenuItem = CreateTrainingOptionsModel.allCases[indexPath.row]
        (cell as? PopUpOptionCell)?.setCell(title: popUpMenuItem.title, and: popUpMenuItem.image)
        (cell as? PopUpOptionCell)?.action = { [unowned self] in
            self.dismiss(animated: true, completion: {
                CreateTrainingOptionsModel.allCases[indexPath.row].onAction()
            })
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CreteTrainingModalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(CreateTrainingOptionsModel.allCases.count)
    }
}
