import UIKit
    
class TESTDTInfoView: UIView {
    
    //MARK: - GUI Elemnts
    lazy var tittleLabe: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Enums
    enum InfoViewType {
        case trainCount
        case gender
        case activityLevel
        case age
        case height
        case weight
    }
    
    //MARK: - Properties
    var tapped: ((TESTDTInfoView.InfoViewType)-> Void)?
    var type: InfoViewType?
    //MARK: - Initialization
    init(type: InfoViewType) {
        super.init(frame: .zero)
        self.type = type
        switch type {
        case .trainCount:
            self.tittleLabe.text = "Total train"
            self.valueLabel.text = "0"
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .gender:
            self.tittleLabe.text = "Gender"
            self.valueLabel.text = "_"
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .activityLevel:
            self.tittleLabe.text = "Activity level"
            self.valueLabel.text = "_"
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .age:
            self.tittleLabe.text = "Age"
            self.valueLabel.text = "0"
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
        case .height:
            self.tittleLabe.text = "Height"
            self.valueLabel.text = "0"
            self.descriptionLabel.text = MeteringSetting.shared.heightDescription
            self.addSubview(self.tittleLabe)
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        case .weight:
            self.tittleLabe.text = "Weight"
            self.valueLabel.text = "0"
            self.descriptionLabel.text = MeteringSetting.shared.weightDescription
            self.addSubview(self.descriptionLabel)
            self.addSubview(self.tittleLabe)
            self.addSubview(self.valueLabel)
            self.setConstraintForDescriptionLabel()
        }
        self.setTapRecognizer()
        self.setAppearance()
        self.setConstraints()
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
    
    //MARK: - Actions
    @objc private func tapSelector() {
        guard let type = self.type else { return }
        self.tapped?(type)
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
            self.valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.valueLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
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
