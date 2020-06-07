import UIKit

protocol DTAproachAlertDelegate: class {
    func cancelAlertPressed()
    func okAlertPressed()
}

class DTAproachAlert: UIView {
    
    //MARK: - GUI Properties
    lazy var tittle: UILabel = {
        let label = UILabel()
        label.text = "Aproach tittle"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var repsTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var repsLabel: UILabel = {
        let label = UILabel()
        label.text = "reps."
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = MeteringSetting.shared.weightDescription + "."
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var okButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: "Ok")
        button.addTarget(self, action: #selector(self.okTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: "Cancel")
        button.addTarget(self, action: #selector(self.cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var weightBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        stackView.addArrangedSubview(self.weightTextField)
        stackView.addArrangedSubview(self.weightLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var repsBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        stackView.addArrangedSubview(self.repsTextField)
        stackView.addArrangedSubview(self.repsLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var infoBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(self.weightBlockStackView)
        stackView.addArrangedSubview(self.repsBlockStackView)
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
    
    //MARK: - Properties
    weak var delegate: DTAproachAlertDelegate?
    weak var exercice: Exercise?
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.setUpMainView()
        self.initView()
    }
    
    init(for exercice: Exercise) {
        super.init(frame: .zero)
        self.setUpMainView()
        self.initView()
        self.exercice = exercice
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private methods
    private func setUpMainView() {
        self.backgroundColor = .viewFlipsideBckgoundColor
        self.alpha = 0
    }
    
    private func initView() {
        self.addSubview(self.tittle)
        self.addSubview(self.infoBlockStackView)
        self.addSubview(self.buttonStackView)
        self.setUpConstraints()
    }
    
    //MARK: - Constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.tittle.topAnchor.constraint(equalTo: self.topAnchor),
            self.tittle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.tittle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.infoBlockStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.infoBlockStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.infoBlockStackView.topAnchor.constraint(equalTo: self.tittle.bottomAnchor),
            self.infoBlockStackView.bottomAnchor.constraint(equalTo: self.buttonStackView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.buttonStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
             self.buttonStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
              self.buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
              self.buttonStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
            
        ])
    }
    
    //MARK: - Actions
    @objc private func okTapped() {
        guard let reps = Int(self.repsTextField.text ?? "0") else { return }
        guard let weight = Double(self.weightTextField.text ?? "0") else { return }
        self.exercice?.addAproachWith(reps, and: weight)
        self.delegate?.okAlertPressed()
    }
    
    @objc private func cancelTapped() {
        self.delegate?.cancelAlertPressed()
    }
}
