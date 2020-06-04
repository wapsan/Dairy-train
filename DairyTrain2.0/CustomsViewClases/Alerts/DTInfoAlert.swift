import UIKit


protocol DTInfoAllerDelegate: class {
    func cancelTapped()
    func okPressed(with alertType: TDInfoiView.InfoViewType)
    
}

class DTInfoAlert: UIView {
    
    //MARK: - GUI Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment  = .center
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var valueTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.font = .boldSystemFont(ofSize: 25)
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .center
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var textFieldWhiteLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var okButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: "Ok")
        button.addTarget(self, action: #selector(self.okPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: "Cancel")
        button.addTarget(self, action: #selector(self.cancelPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
    lazy var maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Male", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.pickerButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Female", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.pickerButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var lowActivivtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Low", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.pickerButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var midActivivtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mid", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.pickerButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var highActivivtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("High", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.pickerButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var pickButtonStakView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(self.okButton)
        stackView.addArrangedSubview(self.cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Private properties
    private var writenValue: String = ""
    
    //MARK: - Piblic properties
    weak var delegate: DTInfoAllerDelegate?
    var allertType: TDInfoiView.InfoViewType?

    //MARK: - Initialization
    init(with infoView: TDInfoiView) {
        super.init(frame: .zero)
        self.allertType = infoView.type
        self.setTextField()
        self.setSelfLayer()
        self.showKeyboard()
        self.setContainerView()
        switch infoView.type {
        case .trainCount:
            break
        case .gender:
             self.initGenderType()
        case .activityLevel:
            self.initActivivtyType()
        case .age:
            self.titleLabel.text = "Set age"
            self.initMetricType()
        case .height:
            self.titleLabel.text = "Set height"
            self.initMetricType()
        case .weight:
            self.titleLabel.text = "Set weight"
            self.initMetricType()
        case .none:
            break
        }
        if infoView.isValueSeted {
            if self.pickButtonStakView.arrangedSubviews.isEmpty {
                self.valueTextField.text = infoView.valueLabel.text
            } else {
                for view in self.pickButtonStakView.arrangedSubviews {
                    guard let button = view as? UIButton else { return }
                    if button.currentTitle == infoView.valueLabel.text {
                        button.isSelected = true
                    }
                    self.setButtonState(button)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setContainerView() {
        self.addSubview(self.containerView)
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    //MARK: - Private methods
    private func setSelfLayer() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowOpacity = 5
    }
    
    private func initMetricType() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.valueTextField)
        self.addSubview(self.textFieldWhiteLine)
        self.addSubview(self.buttonStackView)
        self.setMetricTypeConstraints()
    }
    
    private func initGenderType() {
        self.pickButtonStakView.addArrangedSubview(self.maleButton)
        self.pickButtonStakView.addArrangedSubview(self.femaleButton)
        self.containerView.addSubview(self.buttonStackView)
        self.containerView.addSubview(self.pickButtonStakView)
        self.setPickerTypeConstraints()
    }
    
    private func initActivivtyType() {
        self.pickButtonStakView.addArrangedSubview(self.lowActivivtyButton)
        self.pickButtonStakView.addArrangedSubview(self.midActivivtyButton)
        self.pickButtonStakView.addArrangedSubview(self.highActivivtyButton)
        self.containerView.addSubview(self.buttonStackView)
        self.containerView.addSubview(self.pickButtonStakView)
        self.setPickerTypeConstraints()
    }
    
    private func writeInfo() {
        if self.pickButtonStakView.arrangedSubviews.isEmpty {
            guard let info = self.valueTextField.text else { return }
            if let doubleInfo = Double(info) {
                switch self.allertType {
                case .age:
                    UserModel.shared.setAge(to: Int(doubleInfo))
                case .weight:
                    UserModel.shared.setWeight(to: doubleInfo)
                case .height:
                    UserModel.shared.setHeight(to: doubleInfo)
                default:
                    break
                }
            }
        } else {
            for view in self.pickButtonStakView.arrangedSubviews {
                guard let button = view as? UIButton else { return }
                if button.isSelected {
                    guard let buttonTittle = button.titleLabel?.text else { return }
                    switch self.allertType {
                    case .gender:
                        guard let setedGender = UserModel.Gender.init(rawValue: buttonTittle) else { return }
                        UserModel.shared.setGender(to: setedGender )
                    case .activityLevel:
                        guard let setedActivityLevel = UserModel.ActivivtyLevel.init(rawValue: buttonTittle) else { return }
                        UserModel.shared.setActivivtyLevel(to: setedActivityLevel)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func setButtonState(_ button: UIButton) {
        if button.isSelected {
            button.layer.backgroundColor = UIColor.red.cgColor
        } else {
            button.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    private func setTextField() {
        self.valueTextField.keyboardType = .decimalPad
    }
    
    private func hideKeyboard() {
        self.valueTextField.resignFirstResponder()
    }
    
    private func showKeyboard() {
        self.valueTextField.becomeFirstResponder()
    }

    //MARK: - Constraints
    private func setMetricTypeConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.valueTextField.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.valueTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.valueTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.valueTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.valueTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            self.textFieldWhiteLine.topAnchor.constraint(equalTo: self.valueTextField.bottomAnchor),
            self.textFieldWhiteLine.heightAnchor.constraint(equalToConstant: 1),
            self.textFieldWhiteLine.centerXAnchor.constraint(equalTo: self.valueTextField.centerXAnchor),
            self.textFieldWhiteLine.widthAnchor.constraint(equalTo: self.valueTextField.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.buttonStackView.topAnchor.constraint(greaterThanOrEqualTo:     self.textFieldWhiteLine.bottomAnchor, constant: 8),
            self.buttonStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.buttonStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            
        ])
    }
    
    private func setPickerTypeConstraints() {
        let heightMultiplier: CGFloat =  CGFloat(self.pickButtonStakView.arrangedSubviews.count + 1)
        NSLayoutConstraint.activate([
            self.buttonStackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 16),
            self.buttonStackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -16),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0),
            self.buttonStackView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor, multiplier: 1 / heightMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            self.pickButtonStakView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: -1),
            self.pickButtonStakView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: -1),
            self.pickButtonStakView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 1),
            self.pickButtonStakView.bottomAnchor.constraint(equalTo: self.buttonStackView.topAnchor)
        ])
    }

    //MARK: - Actions
    @objc func pickerButtonPressed(_ button: UIButton) {
        for view in self.pickButtonStakView.arrangedSubviews {
            guard let pickedButton = view as? UIButton else { return }
            if pickedButton != button {
                pickedButton.isSelected = false
                self.setButtonState(pickedButton)
            } else {
                pickedButton.isSelected = true
                self.setButtonState(pickedButton)
            }
        }
    }
    
    @objc private func cancelPressed() {
        self.delegate?.cancelTapped()
        self.valueTextField.text = nil
        self.hideKeyboard()
    }

    @objc private func okPressed() {
        guard let type = self.allertType else { return }
        self.writeInfo()
        self.delegate?.okPressed(with: type)
        self.hideKeyboard()
        self.valueTextField.text = nil
    }
    
}
