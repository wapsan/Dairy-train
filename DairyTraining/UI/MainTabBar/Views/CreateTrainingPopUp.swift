import UIKit

//MARK: - Popup options type
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

final class CreateTrainingPopUp: UIView {
    
    // MARK: - @IBOutlets
    @IBOutlet private var title: UILabel!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var decorateView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var backgroundView: UIView!
    
    // MARK: - Initialization
    static func view() -> CreateTrainingPopUp? {
        let nib = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)
        return nib?.first as? CreateTrainingPopUp
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Lyfecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        decorateView.layer.cornerRadius = decorateView.bounds.height / 2
    }
    
    // MARK: - Public methods
    func preseent() {
        guard let topViewController = UIApplication.topViewController() else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let tabbarController = topViewController.tabBarController,
              let tabbarviee = tabbarController.view else {
            return
        }
        tabbarviee.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: tabbarviee.topAnchor, constant: -100),
            self.leftAnchor.constraint(equalTo: tabbarviee.leftAnchor),
            self.rightAnchor.constraint(equalTo: tabbarviee.rightAnchor),
            self.bottomAnchor.constraint(equalTo: tabbarviee.bottomAnchor)
        ])
        animateInAlert()
    }
    
    // MARK: - Setup
    private func setup() {
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PopUpOptionCell.xibName, bundle: nil),
                           forCellReuseIdentifier: PopUpOptionCell.cellID)
    }
    
    private func hideAlert(completion: (() -> Void)?) {
        self.animateOutAlert {
            completion?()
        }
    }
    
    private func animateInAlert() {
        containerView.transform = .init(translationX: 0, y: containerView.bounds.height)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0.5
            self.containerView.transform = .identity
        }, completion: { _ in
            
        })
    }
    
    private func animateOutAlert(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = 0
            self.containerView.transform = .init(translationX: 0, y: self.containerView.bounds.height)
        }, completion: { _ in
            self.removeFromSuperview()
            completion()
        })
    }
    
    @IBAction func backViewTapped(_ sender: Any) {
        hideAlert(completion: nil)
    }
    
    @IBAction func containerViewDraggin(_ sender: UIPanGestureRecognizer) {
        //TODO - Fix hiding with pan gesture
    }
}

// MARK: - UITableViewDataSource
extension CreateTrainingPopUp: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateTrainingOptionsModel.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopUpOptionCell.cellID, for: indexPath)
        let option = CreateTrainingOptionsModel.allCases[indexPath.row]
        (cell as? PopUpOptionCell)?.setCell(title: option.title, and: option.image)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CreateTrainingPopUp: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideAlert(completion: {
            CreateTrainingOptionsModel.allCases[indexPath.row].onAction()
        })
    }
}
