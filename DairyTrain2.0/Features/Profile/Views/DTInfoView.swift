import UIKit

class DTInfoView: UIView {
    
    //MARK: - Private properties
    private lazy var userInfo = CoreDataManager.shared.readUserMainInfo()
    
    //MARK: - GUI Elemnts
    private(set) lazy var valueLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerViewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var whiteLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.whiteLine)
        stackView.addArrangedSubview(self.valueLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Enums
    enum InfoViewValue {
        case trainCount
        case gender
        case activityLevel
        case age
        case height
        case weight
        
        case totalReps
        case totalAproach
        case avarageProjectileWeight
        case totalWeight
    }
    
    //MARK: - Properties
    private(set) var type: InfoViewValue?
    var tapped: ((DTInfoView.InfoViewValue) -> Void)?
    var isValueSeted: Bool {
        switch self.valueLabel.text {
        case "0","_", "0.0":
            return false
        default:
            return true
        }
    }
    
    //MARK: - Initialization
    init(type: InfoViewValue) {
        super.init(frame: .zero)
        self.type = type
        switch type {
        case .trainCount:
            self.titleLabel.text = LocalizedString.totalTrain
            self.valueLabel.text = String(CoreDataManager.shared.fetchTrainingList().count)
            self.backgroundImage.image = UIImage.totalTraininBackgroundImage
        case .gender:
            self.titleLabel.text = LocalizedString.gender
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayGender ?? "_"
            self.backgroundImage.image = UIImage.genderBackgroundImage
        case .activityLevel:
            self.titleLabel.text = LocalizedString.activityLevel
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayActivityLevel ?? "_"
            self.backgroundImage.image = UIImage.activityLevelBackgroundImage
        case .age:
            self.titleLabel.text = LocalizedString.age
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayAge ?? "0"
            self.backgroundImage.image = UIImage.ageBackgroundImage
        case .height:
            self.titleLabel.text = LocalizedString.height
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayHeight ?? "0"
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
            self.backgroundImage.image = UIImage.heightBackgroundImage
            self.containerStackView.addArrangedSubview(self.descriptionLabel)
        case .weight:
            self.titleLabel.text = LocalizedString.weight
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayWeight ?? "0"
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
            self.backgroundImage.image = UIImage.weightBackgroundImage
            self.containerStackView.addArrangedSubview(self.descriptionLabel)
        case .totalReps:
            self.titleLabel.text = LocalizedString.totalReps
            self.backgroundImage.image = UIImage.totalRepsBackgroundImage
        case .totalAproach:
            self.titleLabel.text = LocalizedString.totalAproach
            self.backgroundImage.image = UIImage.totalAproachBackgroundImage
        case .avarageProjectileWeight:
            self.titleLabel.text = LocalizedString.avarageProjectileWeigt
            self.backgroundImage.image = UIImage.avareProjectileWeightBackgroundImage
        case .totalWeight:
            self.titleLabel.text = LocalizedString.totalTrainWeight
            self.backgroundImage.image = UIImage.totalTrainingWeightbackgroundImage
        }
        
        self.initView()
        self.setTapRecognizer()
        self.addObserverForMeteringSetting()
        self.setShadowForMainView()
    }
    
    private func initView() {
        self.addSubview(self.containerViewView)
        self.containerViewView.addSubview(self.backgroundImage)
        self.backgroundImage.addSubview(self.containerStackView)
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setter
    func setValueLabelTo(_ text: String) {
        self.valueLabel.text = text
    }
    
    //MARK: - Private methods
    private func setShadowForMainView() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
    private func setTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapSelector))
        self.addGestureRecognizer(tap)
    }
    
    private func addObserverForMeteringSetting() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.heightSettingWasChanged),
                                               name: .heightMetricChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.weightSettingChanged),
                                               name: .weightMetricChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.newTrainAded),
                                               name: .trainingListWasChanged,
                                               object: nil)
        
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.containerViewView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerViewView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.containerViewView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.containerViewView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.containerStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 8),
           // self.containerStackView.topAnchor.constraint(lessThanOrEqualTo: self.topAnchor, constant: 8),
            self.containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.backgroundImage.topAnchor.constraint(equalTo: self.containerViewView.topAnchor),
            self.backgroundImage.leftAnchor.constraint(equalTo: self.containerViewView.leftAnchor),
            
            self.backgroundImage.rightAnchor.constraint(equalTo: self.containerViewView.rightAnchor),
            
            self.backgroundImage.bottomAnchor.constraint(equalTo: self.containerViewView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.whiteLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    //MARK: - Actions
    @objc private func tapSelector() {
        guard let type = self.type else { return }
        self.tapped?(type)
    }
    
    @objc private func heightSettingWasChanged() {
        guard let type = self.type else { return }
        if type == .height {
            guard let userInfo = self.userInfo else { return }
            self.valueLabel.text = userInfo.displayHeight
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
        }
    }
    
    @objc private func weightSettingChanged() {
        guard let type = self.type else { return }
        if type == .weight {
            guard let userInfo = self.userInfo else { return }
            self.valueLabel.text = userInfo.displayWeight
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
        }
    }
    
    @objc private func newTrainAded() {
        print("New train aded")
        guard let type = self.type else { return }
        if type == .trainCount {
            self.valueLabel.text = String(CoreDataManager.shared.fetchTrainingList().count)
        }
    }
}
