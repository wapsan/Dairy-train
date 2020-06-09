import UIKit
    
class TDInfoView: UIView {
    
    //MARK: - GUI Elemnts
    lazy var tittleLabe: DTAdaptiveLabel = {
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
    }
    
    //MARK: - Properties
    var tapped: ((TDInfoView.InfoViewValue)-> Void)?
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
            self.tittleLabe.text = "Total train"
            self.valueLabel.text = UserModel.shared.displayTrainCount
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .gender:
            self.tittleLabe.text = "Gender"
            self.valueLabel.text = UserModel.shared.displayGender
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .activityLevel:
            self.tittleLabe.text = "Activity level"
            self.valueLabel.text = UserModel.shared.displayActivityLevel
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .age:
            self.tittleLabe.text = "Age"
            self.valueLabel.text = UserModel.shared.displayAge
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .height:
            self.tittleLabe.text = "Height"
            self.valueLabel.text = UserModel.shared.displayHeight
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
            self.addSubview(self.tittleLabe)
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        case .weight:
            self.tittleLabe.text = "Weight"
            self.valueLabel.text = UserModel.shared.displayWeight
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
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
        self.addSubview(self.tittleLabe)
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
            self.tittleLabe.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.tittleLabe.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.tittleLabe.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.tittleLabe.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
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
            self.descriptionLabel.topAnchor.constraint(equalTo: self.tittleLabe.bottomAnchor, constant: 0),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.valueLabel.topAnchor, constant: 0)
        ])
    }
    
}
