import UIKit


protocol DTTestCustomAllerDelegate: class {
    func cancelTapped()
    func okPressed(with alertType: TESTDTInfoView.InfoViewType, and writtenInfo: String)
    
}

class DTTestCustomAllert: UIView {
    
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var textFieldWhiteLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ok", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.okPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
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
        stackView.distribution = .fill
        stackView.addArrangedSubview(self.okButton)
        stackView.addArrangedSubview(self.cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Private properties
    private var writenValue: String = ""
    
    //MARK: - Piblic properties
    weak var delegate: DTTestCustomAllerDelegate?
    var allertType: TESTDTInfoView.InfoViewType?

    //MARK: - Initialization
    init(type: TESTDTInfoView.InfoViewType) {
        super.init(frame: .zero)
        self.allertType = type
        self.setTextField()
        self.setSelfLayer()
        self.showKeyboard()
        switch type {
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
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setSelfLayer() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
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
        self.addSubview(self.buttonStackView)
        self.addSubview(self.pickButtonStakView)
        self.setPickerTypeConstraints()
    }
    
    private func initActivivtyType() {
        self.pickButtonStakView.addArrangedSubview(self.lowActivivtyButton)
        self.pickButtonStakView.addArrangedSubview(self.midActivivtyButton)
        self.pickButtonStakView.addArrangedSubview(self.highActivivtyButton)
        self.addSubview(self.buttonStackView)
        self.addSubview(self.pickButtonStakView)
        self.setPickerTypeConstraints()
    }
    
    private func writeInfo() {
        if self.pickButtonStakView.arrangedSubviews.isEmpty {
            guard let info = self.valueTextField.text else { return }
            if let _ = Double(info) {
                self.writenValue = info
            }
        } else {
            for view in self.pickButtonStakView.arrangedSubviews {
                guard let button = view as? UIButton else { return }
                if button.isSelected {
                    guard let buttonTittle = button.titleLabel?.text else { return }
                    self.writenValue = buttonTittle
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
            self.buttonStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.buttonStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.buttonStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / heightMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            self.pickButtonStakView.topAnchor.constraint(equalTo: self.topAnchor, constant: -1),
            self.pickButtonStakView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -1),
            self.pickButtonStakView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 1),
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
        self.delegate?.okPressed(with: type, and: self.writenValue)
        self.hideKeyboard()
        self.valueTextField.text = nil
    }
    
}
