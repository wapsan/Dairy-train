import UIKit

protocol NewAproachAlertDelegate: AnyObject {
    func newAproachAlertOkPressed(newAproachAlert: DTNewAproachAlert,
                                  with weight: Float,
                                  and reps: Int,
                                  and exerciceIndex: Int)
    
    func changeAproachAlertOkPressed(changeAproachAlert: DTNewAproachAlert,
                                     at aproachIndex: Int,
                                     and exerciseIndex: Int,
                                     with weight: Float,
                                     and reps: Int)
    
    func newAproachAlertCancelPressed(newAproachAlert: DTNewAproachAlert)
}

class DTNewAproachAlert: UIView {
    
    //MARK: - Enumaration aproach type
    enum AproachAlertType {
        case new
        case change
    }
        
    //MARK: - Properties
    weak var delegate: NewAproachAlertDelegate?
    var alertType: AproachAlertType?
    private lazy var aproachIndex = 0
    
    //MARK: - GUI Properties
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = DTColors.backgroundColor
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1
        view.layer.borderColor = DTColors.controllBorderColor.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerAlertView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tapForVisualEffectView: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.cancelPressed))
        return tap
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.addGestureRecognizer(self.tapForVisualEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var okButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: LocalizedString.ok)
        button.addTarget(self, action: #selector(self.okPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: LocalizedString.cancel)
        button.addTarget(self, action: #selector(self.cancelPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var systemButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.okButton)
        stackView.addArrangedSubview(self.cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: DTAdaptiveLabel = {
        let label = DTAdaptiveLabel()
        label.textColor = .white
        label.textAlignment  = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var repsTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = UILabel()
        label.text = " Reps."
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.backgroundColor = .clear
        label.textColor = .white
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = MeteringSetting.shared.weightDescription
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(self.weightTextField)
        stackView.addArrangedSubview(self.weightLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var repsBlockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(self.repsTextField)
        stackView.addArrangedSubview(self.repsLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoBlockStackView: UIStackView = {
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
    
    //MARK: - Initialization
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var exrciseIndex: Int = 0
    
    //MARK: - Public methods
    func present(on viewController: UIViewController,
                 with aporachListCount: Int,
                 and exerciceIndex: Int) {
        self.alertType = .new
        viewController.view.addSubview(self)
        self.exrciseIndex = exerciceIndex
        self.setUpAlert()
        self.setTitle(for: aporachListCount)
      //  self.setDefaultValueForTextFields()
        self.showKeyBoard()
        self.animateInAlert()
    }
    
    func present(on viewController: UIViewController,
                 for aproachIndex: Int,
                 and exerciseIndex: Int,
                 weight: Float,
                 reps: Int) {
        self.alertType = .change
        viewController.view.addSubview(self)
        self.exrciseIndex = exerciseIndex
        self.aproachIndex = aproachIndex
        self.setUpAlert()
        self.setUpDefaultValuesForApproach(to: aproachIndex, weigth: weight , reps: reps)
        self.showKeyBoard()
        self.animateInAlert()
    }
    
    func hideAlert() {
        self.hideKeyboard()
        self.animateOutAlert()
        
    }
    
    //MARK: - Actions
    @objc func okPressed() {
        guard let stringWeight = self.weightTextField.text,
            let stringReps = self.repsTextField.text,
            let weight = Float(stringWeight),
            let reps = Int(stringReps) else { return }
        guard let alertType = self.alertType else { return }
        switch alertType {
        case .new:
            self.delegate?.newAproachAlertOkPressed(newAproachAlert: self,
                                                    with: weight,
                                                    and: reps,
                                                    and: self.exrciseIndex)
        case .change:
            self.delegate?.changeAproachAlertOkPressed(changeAproachAlert: self,
                                                       at: self.aproachIndex,
                                                       and: self.exrciseIndex,
                                                       with: weight, and: reps)
        }
    }
    
    @objc func cancelPressed() {
        self.hideAlert()
    }
}

//MARK: - Private extension
private extension DTNewAproachAlert {
    
    func setUpDefaultValuesForApproach(to numberOfAproach: Int, weigth: Float, reps: Int) {
        self.setTitle(for: numberOfAproach)
        if weigth.truncatingRemainder(dividingBy: 1) == 0 {
             self.weightTextField.text = String(Int(weigth))
        } else {
           self.weightTextField.text = String(weigth)
        }
        self.repsTextField.text = String(reps)
    }
    
    func setTitle(for aproachIndex: Int) {
        self.titleLabel.text = "Aproach № \(aproachIndex + 1)"
    }
    
    func setDefaultValueForTextFields() {
        self.repsTextField.text = ""
        self.weightTextField.text = ""
    }

    func showKeyBoard() {
        self.weightTextField.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        if self.repsTextField.isEditing {
            self.repsTextField.resignFirstResponder()
        } else {
            self.weightTextField.resignFirstResponder()
        }
    }
    
    func animateInAlert() {
        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alertView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        })
    }
    
    func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.alertView.alpha = 0
                        self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       // self.valueTextField.resignFirstResponder()
        }) { [weak self] _ in
            guard let self = self else { return }
            self.setDefaultValueForTextFields()
            self.cleanViews()
            self.deactivateAllConstraints()
            self.removeFromSuperview()
        }
    }
    
    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)
    }
    
    func cleanViews() {
        self.alertView.subviews.forEach({ $0.removeFromSuperview() })
    }
    

    func setUpAlert() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.infoBlockStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.titleLabel.text = "some"
        self.setUpDefaultsConstraints()
    }
    
    
    
    func setUpDefaultsConstraints() {
        guard let superView = self.superview else { return }
        let safeArea = superView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            self.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            self.visualEffectView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.visualEffectView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let widthContainerAlertViewConstraint = NSLayoutConstraint(item: self.alertView,
                                                                   attribute: .width,
                                                                   relatedBy: .equal,
                                                                   toItem: self.alertView,
                                                                   attribute: .height,
                                                                   multiplier: 1,
                                                                   constant: 0)
        widthContainerAlertViewConstraint.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            self.alertView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor,
                                                constant: DTEdgeInsets.small.top),
            self.alertView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            self.alertView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.alertView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            widthContainerAlertViewConstraint
        ])
        
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                  constant: DTEdgeInsets.small.left),
            self.titleLabel.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                   constant: DTEdgeInsets.small.right)
        ])
        
        NSLayoutConstraint.activate([
            self.infoBlockStackView.centerYAnchor.constraint(equalTo: self.alertView.centerYAnchor),
            self.infoBlockStackView.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
            self.infoBlockStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.infoBlockStackView.bottomAnchor.constraint(equalTo: self.systemButtonsStackView.topAnchor),
            self.infoBlockStackView.widthAnchor.constraint(equalTo: self.alertView.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            self.repsTextField.widthAnchor.constraint(equalTo: self.infoBlockStackView.widthAnchor,
                                                      multiplier: 1/3),
            self.weightTextField.widthAnchor.constraint(equalTo: self.infoBlockStackView.widthAnchor,
                                                        multiplier: 1/3)
        ])
        
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor,
                                                              constant: DTEdgeInsets.small.left),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor,
                                                               constant: DTEdgeInsets.small.right),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor,
                                                                constant: DTEdgeInsets.small.bottom),
            self.systemButtonsStackView.heightAnchor.constraint(equalTo: self.alertView.heightAnchor,
                                                                multiplier: 0.25)
        ])
    }
}
