import UIKit

class TrainStatisticsViewController: MainTabBarItemVC {
    
    //MARK: - Private properties
    private var statistics: Statistics?
    private var trainDate: String?
    private lazy var edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: -16)
    
    //MARK: - GUI Properties
    private lazy var totalWeightView: DTInfoView = {
        let view = DTInfoView(type: .totalWeight)
        view.setValueLabelTo(self.statistics?.totalWorkoutWeight ?? "0")
        return view
    }()
    
    private lazy var avaragepProgectileWeightView: DTInfoView = {
        let view = DTInfoView(type: .avarageProjectileWeight)
        view.setValueLabelTo(self.statistics?.averageProjectileWeight ?? "0")
        return view
    }()
    
    private lazy var totalRepsView: DTInfoView = {
        let view = DTInfoView(type: .totalReps)
        view.setValueLabelTo(self.statistics?.totalNumberOfReps ?? "0")
        return view
    }()
    
    private lazy var totalAproachesView: DTInfoView = {
        let view = DTInfoView(type: .totalAproach)
        view.setValueLabelTo(self.statistics?.totalNumberOfAproach ?? "0")
        return view
    }()
    
    private lazy var trainedMusclesView: DTTrainedMusclesView = {
        let view = DTTrainedMusclesView(for: self.statistics?.trainedSubGroupsList)
        return view
    }()
    
    private lazy var repsAndAproachStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.totalRepsView)
        stackView.addArrangedSubview(self.totalAproachesView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.repsAndAproachStackView)
        stackView.addArrangedSubview(self.totalWeightView)
        stackView.addArrangedSubview(self.avaragepProgectileWeightView)
        stackView.addArrangedSubview(self.trainedMusclesView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpNavigationBar()
    }
    
    //MARK: - Private methods
    private func setUpNavigationBar() {
        self.navigationItem.title = self.trainDate
    }
    
    private func setUpView() {
        self.view.addSubview(self.mainContainerStackView)
        self.setUpConstraints()
        self.addObserverForTrainigChanged()
    }
    
    private func addObserverForTrainigChanged() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.trainingWasChanged(_:)),
                                               name: .trainingWasChanged,
                                               object: nil)
    }
    
    //MARK: - Public methods
    func setTrain(to train: TrainingManagedObject) {
        self.statistics = Statistics(for: train)
        self.trainDate = train.formatedDate
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.mainContainerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                             constant: self.edgeInsets.top),
            self.mainContainerStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                              constant: self.edgeInsets.left),
            self.mainContainerStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                               constant: self.edgeInsets.right),
            self.mainContainerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                                constant: self.edgeInsets.bottom),
        ])
    }
    
    //MARK: - Actions
    @objc private func trainingWasChanged(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let train = userInfo["Train"] as? TrainingManagedObject else { return }
        self.trainedMusclesView.updateSubgroupsImages(for: train.muscleSubgroupInCurentTraint)
    }
}
