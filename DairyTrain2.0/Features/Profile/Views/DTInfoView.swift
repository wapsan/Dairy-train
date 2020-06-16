import UIKit
    
class DTInfoView: UIView {
        
    //MARK: - GUI Elemnts
    lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var valueLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        case numberOfSubgroups
        case avarageProjectileWeight
        case totalWeight
    }
    
    //MARK: - Properties
    var tapped: ((DTInfoView.InfoViewValue)-> Void)?
    var type: InfoViewValue?
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
            self.titleLabel.text = "Total train"
            self.valueLabel.text = UserModel.shared.displayTrainCount
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .gender:
            self.titleLabel.text = "Gender"
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.gender ?? "_"
                //String(self.profileManager.profileInfo?.gender?.rawValue ?? "_")
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .activityLevel:
            self.titleLabel.text = "Activity level"
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.activitylevel ?? "_"
                //String(self.profileManager.profileInfo?.activityLevel?.rawValue ?? "_")
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .age:
            self.titleLabel.text = "Age"
            self.valueLabel.text = String(CoreDataManager.shared.readUserMainInfo()?.age ?? 0)
                //String(self.profileManager.profileInfo?.age ?? 0)
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .height:
            self.titleLabel.text = "Height"
            self.valueLabel.text = String(CoreDataManager.shared.readUserMainInfo()?.height ?? 0)
                //String(self.profileManager.profileInfo?.height ?? 0)
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        case .weight:
            self.titleLabel.text = "Weight"
            self.valueLabel.text = String(CoreDataManager.shared.readUserMainInfo()?.weight ?? 0)
                //String(self.profileManager.profileInfo?.weight ?? 0)
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        case .totalReps:
            self.titleLabel.text = "Total reps"
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .totalAproach:
            self.titleLabel.text = "Total aproach"
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .numberOfSubgroups:
            self.titleLabel.text = "Number of muscle subgroups"
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .avarageProjectileWeight:
            self.titleLabel.text = "Avarage projectile weight"
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .totalWeight:
            self.titleLabel.text = "Total train weight"
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        }
        self.setTapRecognizer()
        self.setAppearance()
        self.setConstraints()
        self.addObserverForMeteringSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setLayotLayer()
    }
    
    //MARK: - Private methods
    private func setAppearance() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.addSubview(self.titleLabel)
        self.addSubview(self.valueLabel)
        self.setDefaultLayer()
    }
    
    private func setDefaultLayer() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
    private  func setLayotLayer() {
        self.layer.cornerRadius = 25
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
                                               name: .addNewTrain,
                                               object: nil)
        
    }
    
    //MARK: - Actions
    @objc private func tapSelector() {
        guard let type = self.type else { return }
        self.tapped?(type)
    }
    
    @objc private func heightSettingWasChanged() {
     guard let type = self.type else { return }
        if type == .height {
            guard let height = Double(UserModel.shared.displayHeight) else { return }
            let multipliedHeight = height * MeteringSetting.shared.heightMultiplier
            let roundedHeight = Double(round(10 * multipliedHeight) / 10)
            UserModel.shared.setHeight(to: roundedHeight)
            self.valueLabel.text = UserModel.shared.displayHeight
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
        }
    }
    
    @objc private func weightSettingChanged() {
        guard let type = self.type else { return }
        if type == .weight {
            guard let weight = Double(UserModel.shared.displayWeight) else { return }
            let multipliedWeight = weight * MeteringSetting.shared.weightMultiplier
            let roundedWeight = Double(round(10 * multipliedWeight) / 10)
            UserModel.shared.setWeight(to: roundedWeight)
            self.valueLabel.text = UserModel.shared.displayWeight
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
        }
    }
    
    @objc private func newTrainAded() {
        print("New train aded")
        guard let type = self.type else { return }
        if type == .trainCount {
            self.valueLabel.text = String(UserModel.shared.trains.count)
        }
    }
    
    //MARK: - Constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])

        NSLayoutConstraint.activate([
            self.valueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.valueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.valueLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35)
        ])
    }
    
    private func setConstraintForDescriptionLabel() {
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.valueLabel.topAnchor, constant: 0)
        ])
    }
    
}
