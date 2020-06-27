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
      //  case numberOfSubgroups
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
            self.valueLabel.text = UserModel.shared.displayTrainCount
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .gender:
            self.titleLabel.text = LocalizedString.gender
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayGender
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .activityLevel:
            self.titleLabel.text = LocalizedString.activityLevel
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayActivityLevel
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .age:
            self.titleLabel.text = LocalizedString.age
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayAge
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .height:
            self.titleLabel.text = LocalizedString.height
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayHeight
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        case .weight:
            self.titleLabel.text = LocalizedString.weight
            self.valueLabel.text = CoreDataManager.shared.readUserMainInfo()?.displayWeight
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        case .totalReps:
            self.titleLabel.text = LocalizedString.totalReps
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .totalAproach:
            self.titleLabel.text = LocalizedString.totalAproach
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
//        case .numberOfSubgroups:
//            self.titleLabel.text = "Number of muscle subgroups"
//            self.addSubview(self.titleLabel)
//            self.addSubview(self.valueLabel)
        case .avarageProjectileWeight:
            self.titleLabel.text = LocalizedString.avarageProjectileWeigt
            self.addSubview(self.titleLabel)
            self.addSubview(self.valueLabel)
        case .totalWeight:
            self.titleLabel.text = LocalizedString.totalTrainWeight
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
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.viewFlipsideBckgoundColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 30
        gradientLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
     //   gradientLayer.borderColor = UIColor.red.cgColor
        gradientLayer.borderWidth = 1
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = .init(width: 0, height: 5)
        gradientLayer.shadowOpacity = 5
        self.layer.insertSublayer(gradientLayer, at:0)
      //  self.setLayotLayer()
      //  self.setDefaultLayer()
    }
    
    //MARK: - Private methods
    private func setAppearance() {
        
        
        self.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.valueLabel)
       // self.setDefaultLayer()
    }
    
    private func setDefaultLayer() {
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
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
            guard let height = CoreDataManager.shared.readUserMainInfo()?.height else { return }
            let multipliedHeight = height * MeteringSetting.shared.heightMultiplier
            let newHeight = Float(round(10 * multipliedHeight) / 10)
            CoreDataManager.shared.updateHeight(to: newHeight)
            self.valueLabel.text = String(CoreDataManager.shared.readUserMainInfo()?.height ?? 0)
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
        }
    }
    
    @objc private func weightSettingChanged() {
        guard let type = self.type else { return }
        if type == .weight {
            guard let weight = CoreDataManager.shared.readUserMainInfo()?.weight else { return }
            let multipliedWeight = weight * MeteringSetting.shared.weightMultiplier
            let newWeight = Float(round(10 * multipliedWeight) / 10)
            CoreDataManager.shared.updateWeight(to: newWeight)
            self.valueLabel.text = String(CoreDataManager.shared.readUserMainInfo()?.weight ?? 0)
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
