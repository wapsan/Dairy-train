import UIKit

class TrainStatisticsVC: MainTabBarItemVC {
    
    //MARK: - Private properties
    private var statistics: Statistics?
    private var trainDate: String?
    
    //MARK: - GUI Properties
    lazy var totalWeightView: DTInfoView = {
        let view = DTInfoView(type: .totalWeight)
        view.valueLabel.text = String(self.statistics?.totalWorkoutWeight ?? 0)
        return view
    }()
    
    lazy var numberOfTrainedSubgroupsView: DTInfoView = {
        let view = DTInfoView(type: .numberOfSubgroups)
        view.valueLabel.text = String(self.statistics?.numberOfTrainedSubgroups ?? 0)
        return view
    }()
    
    lazy var avaragepProgectileWeightView: DTInfoView = {
        let view = DTInfoView(type: .avarageProjectileWeight)
        view.valueLabel.text = String(format: "%.2f", self.statistics?.averageProjectileWeight ?? 0)
        return view
    }()
    
    lazy var totalRepsView: DTInfoView = {
        let view = DTInfoView(type: .totalReps)
        view.valueLabel.text = String(self.statistics?.totalNumberOfReps ?? 0)
        return view
    }()
    
    lazy var totalAproachesView: DTInfoView = {
        let view = DTInfoView(type: .totalAproach)
        view.valueLabel.text = String(self.statistics?.totalNumberOfAproach ?? 0)
        return view
    }()
    
    lazy var repsAndAproachStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.totalRepsView)
        stackView.addArrangedSubview(self.totalAproachesView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var subgroupsAndAvarageWeightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.numberOfTrainedSubgroupsView)
        stackView.addArrangedSubview(self.avaragepProgectileWeightView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var mainContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.totalWeightView)
        stackView.addArrangedSubview(self.repsAndAproachStackView)
        stackView.addArrangedSubview(self.subgroupsAndAvarageWeightStackView)
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
    }
    
    //MARK: - Public methods
    func setTrain(to train: Train) {
        self.statistics = Statistics(for: train)
        self.trainDate = train.dateTittle
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.mainContainerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            self.mainContainerStackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            self.mainContainerStackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            self.mainContainerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
        ])
    }
}
