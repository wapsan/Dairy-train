import UIKit

class TrainStatisticsViewController: MainTabBarItemVC {
    
    //MARK: - Properties
    var viewModel: TrainStatisticsViewModel?
    
    //MARK: - GUI Properties
    private lazy var totalWeightView: DTMainInfoView = {
        let view = DTMainInfoView(type: .totalWeight, and: self.view)
        return view
    }()
    
    private lazy var avaragepProgectileWeightView: DTMainInfoView = {
        let view = DTMainInfoView(type: .avarageProjectileWeight, and: self.view)
        return view
    }()
    
    private lazy var totalRepsView: DTMainInfoView = {
        let view = DTMainInfoView(type: .totalReps, and: self.view)
        return view
    }()
    
    private lazy var totalAproachesView: DTMainInfoView = {
        let view = DTMainInfoView(type: .totalAproach, and: self.view)
        return view
    }()
    
    private lazy var trainedMusclesView: DTTrainedMusclesView = {
        let view = DTTrainedMusclesView(for: self.viewModel?.tainedSubgroupList)
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
        self.viewModel?.loadStatistcis()
        self.setUpViewController()
        self.setUI()
    }
    
    func setUI() {
        self.totalWeightView.valueLabel.text = self.viewModel?.totalWorkoutWeight
        self.totalRepsView.valueLabel.text = self.viewModel?.totalReps
        self.totalAproachesView.valueLabel.text = self.viewModel?.totalAproach
        self.avaragepProgectileWeightView.valueLabel.text = self.viewModel?.avaragePorjectioleWeight
        
        self.navigationItem.title = self.viewModel?.trainingDate//self.trainDate
    }
    
    //MARK: - Private methods
    private func setUpViewController() {
        self.view.addSubview(self.mainContainerStackView)
        self.setUpConstraints()
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
}
