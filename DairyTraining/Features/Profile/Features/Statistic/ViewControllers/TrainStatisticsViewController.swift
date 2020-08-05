import UIKit

class TrainStatisticsViewController: MainTabBarItemVC {
    
    //MARK: - Private properties
    private var statistics: Statistics?
    private var trainDate: String?
    
    //MARK: - GUI Properties
    private lazy var totalWeightView: DTMainInfoView = {
        let view = DTMainInfoView(type: .totalWeight, and: self.view)
        view.setValueLabelTo(self.statistics?.totalWorkoutWeight ?? "0")
        return view
    }()
    
    private lazy var avaragepProgectileWeightView: DTMainInfoView = {
        let view = DTMainInfoView(type: .avarageProjectileWeight, and: self.view)
        view.setValueLabelTo(self.statistics?.averageProjectileWeight ?? "0")
        return view
    }()
    
    private lazy var totalRepsView: DTMainInfoView = {
        let view = DTMainInfoView(type: .totalReps, and: self.view)
        view.setValueLabelTo(self.statistics?.totalNumberOfReps ?? "0")
        return view
    }()
    
    private lazy var totalAproachesView: DTMainInfoView = {
        let view = DTMainInfoView(type: .totalAproach, and: self.view)
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
                                                             constant: DTEdgeInsets.medium.top),
            self.mainContainerStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor,
                                                              constant: DTEdgeInsets.medium.left),
            self.mainContainerStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor,
                                                               constant: DTEdgeInsets.medium.right),
            self.mainContainerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                                                constant: DTEdgeInsets.medium.bottom),
        ])
    }
    
    //MARK: - Actions
    @objc private func trainingWasChanged(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let train = userInfo["Train"] as? TrainingManagedObject else { return }
        self.trainedMusclesView.updateSubgroupsImages(for: train.muscleSubgroupInCurentTraint)
    }
}
