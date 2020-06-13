import UIKit

@objc protocol DTCustomAlertDelegate: class {
    @objc optional func alertOkPressed()
    @objc optional func alertCancelPressed()
}

class DTCustomAlert: UIView {
    
    //MARK: - Singletone propertie
    static let shared = DTCustomAlert()
    private lazy var profileManager = ProfileInfoFileManager.shared
    //MARK: - Enum
    /**
    Type, wich set alert behavor for write data for user model.
     - **setValue** - type which set one of user parametrs like age, weight, gender etc.
     - **newAproachAlert** - type using for changing in training  approaches
     - **aproachAlert** -  type using for add new approaches
    */
    enum AlertType {
        case setValue
        case newAproachAlert
        case aproachAlert
    }
    
    //MARK: - Private properties
    /**
        Property based on tapped view type
    */
    private var alertType: DTCustomAlert.AlertType?
    private var changingAproachIndex: Int?
    private weak var exercice: Exercise?
    private weak var tappedInfoView: DTInfoView?
    private lazy var setAgeTitle = "Set age"
    private lazy var setWeightTitle = "Set weight"
    private lazy var setHeightTitle = "Set height"
    
    //MARK: - Public properties
    weak var delegate: DTCustomAlertDelegate?
    
    //MARK: - Default GUI Properties
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .viewFlipsideBckgoundColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerAlertView: UIView = {
         let view = UIView()
         view.backgroundColor = .viewFlipsideBckgoundColor
         view.layer.cornerRadius = 20
         view.layer.shadowColor = UIColor.black.cgColor
         view.layer.shadowOffset = .init(width: 0, height: 5)
         view.layer.shadowOpacity = 5
         view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffectView = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffectView)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var okButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: "Ok")
        button.addTarget(self, action: #selector(self.okPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: DTInfoAlertButton = {
        let button = DTInfoAlertButton(title: "Cancel")
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
    
    //MARK: - Weight/Height/Age type GUI properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment  = .center
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var valueTextField: DTTextField = {
           let textField = DTTextField(placeholder: "")
           textField.font = .boldSystemFont(ofSize: 25)
           textField.adjustsFontSizeToFitWidth = true
           textField.textAlignment = .center
           textField.textColor = .white
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
    }()
    
    //MARK: - Gender type GUI properties
    private lazy var maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Male", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Female", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Activity type GUI properties
    private lazy var lowActivivtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Low", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var midActivivtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mid", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var highActivivtyButton: UIButton = {
        let button = UIButton()
        button.setTitle("High", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.selectListButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var selectionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -1
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Aproach type GUI properties
    private lazy var repsTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var repsLabel: UILabel = {
        let label = UILabel()
        label.text = "reps."
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightTextField: DTTextField = {
        let textField = DTTextField(placeholder: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = MeteringSetting.shared.weightDescription + "."
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
        stackView.alignment = .lastBaseline
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
        stackView.alignment = .lastBaseline
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
       // self.setAlertViewLayer()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    /**
        Method which show custom alert with **setValue** type
           - Parameter viewController: UIViewControler which will be shown custom alert.
           - Parameter infoView: TDInfoView by clicking on which alert was called
     */
    func showInfoAlert(on viewController: UIViewController, with infoView: DTInfoView) {
        viewController.view.addSubview(self)
        self.tappedInfoView = infoView
        guard let infoViewType = infoView.type else { return }
        switch infoViewType {
        case .gender:
            self.setUpGenderAlertType()
        case .activityLevel:
            self.setUpActivityLevelAlertType()
        case .age, .height, .weight:
            self.setUpValueAlertType(with: infoViewType)
            self.setUpKeyBoardStyle(for: self.valueTextField)
            self.showKeyboard(for: self.valueTextField)
        default:
            break
        }
        
        self.delegate = viewController as? DTCustomAlertDelegate
        self.alertType = .setValue
        self.setUpDefaultsValue(with: infoView)
        self.animateInAlert()
    }
    
    /**
       Method which show custom alert with **aproachAlert** or **newAproachAlert** type
          - Parameter viewController: UIViewControler which will be shown custom alert.
          - Parameter exercice: Exercice in wich will add aproach data from alert.
          - Parameter aproachNumber: Aproach wich will be changed, if you add new aproach this parameter must be **nill**
    */
    func showAproachAlert(on viewController: UIViewController,
                          with exercice: Exercise,
                          and aproachNumber: Int?) {
        if let aproachIndex = aproachNumber {
            let aproach = exercice.aproaches[aproachIndex]
            self.titleLabel.text = "Aproach №\(aproachIndex + 1)"
            if aproach.weight.truncatingRemainder(dividingBy: 1) == 0 {
                self.weightTextField.text = String(format: "%.0f", aproach.weight)
            } else {
                self.weightTextField.text = String(format: "%.1f", aproach.weight)
            }
            self.repsTextField.text = String(exercice.aproaches[aproachIndex].reps)
            self.changingAproachIndex = aproachIndex
            self.alertType = .aproachAlert
        } else {
            self.alertType = .newAproachAlert
            self.titleLabel.text = "Aproach №\(exercice.aproaches.count + 1)"
            self.setUpDefaultsAproach()
        }
        
        viewController.view.addSubview(self)
        self.delegate = viewController as? DTCustomAlertDelegate
        self.exercice = exercice
        self.setUpKeyBoardStyle(for: self.weightTextField)
        self.setUpKeyBoardStyle(for: self.repsTextField)
        self.showKeyboard(for: self.weightTextField)
        self.setUpAproachAlertType()
        self.animateInAlert()
    }

    //MARK: - Private methods
    private func setUpDefaultsValue(with infoView: DTInfoView) {
        if infoView.isValueSeted {
            guard let infoViewType = infoView.type else { return }
            switch infoViewType {
            case .gender, .activityLevel:
                for view in self.selectionButtonsStackView.arrangedSubviews {
                    guard let button = view as? UIButton else { return }
                    if button.currentTitle == infoView.valueLabel.text {
                        button.isSelected = true
                    }
                    self.setButtonState(button)
                }
            case .age, .height, .weight:
                self.valueTextField.text = infoView.valueLabel.text
            default:
                break
            }
        } else {
            self.valueTextField.text = ""
        }
    }
    
    private func setUpDefaultsAproach() {
        self.repsTextField.text = ""
        self.weightTextField.text = ""
    }
    
    private func animateInAlert() {
        self.containerAlertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.containerAlertView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.alpha = 1
            self.containerAlertView.alpha = 1
            self.containerAlertView.transform = CGAffineTransform.identity
        })
    }
    
    private func animateOutAlert() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.visualEffectView.alpha = 0
                        self.containerAlertView.alpha = 0
                        self.containerAlertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            guard let _ = self.superview else { return }
            self.cleanViews()
            self.deactivateAllConstraints()
            self.removeFromSuperview()
        }
    }
    
    private func hideAlert() {
        self.hideKeyboard()
        self.animateOutAlert()
    }
    
    private func setDefaultAlertType() {
        self.addSubview(self.visualEffectView)
        self.addSubview(self.containerAlertView)
        self.containerAlertView.addSubview(self.alertView)
        self.setUpDefaultsConstraints()
    }
    
    private func setUpValueAlertType(with valueToSet: DTInfoView.InfoViewValue) {
        self.setDefaultAlertType()
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.valueTextField)
        self.alertView.addSubview(self.systemButtonsStackView)
        switch valueToSet {
        case .age:
            self.titleLabel.text = self.setAgeTitle
        case .height:
            self.titleLabel.text = self.setHeightTitle
        case .weight:
            self.titleLabel.text = self.setWeightTitle
        default:
            break
        }
        self.setUpValueAlertTypeConstraints()
    }
    
    private func setUpGenderAlertType() {
        self.setDefaultAlertType()
        self.selectionButtonsStackView.addArrangedSubview(self.maleButton)
        self.selectionButtonsStackView.addArrangedSubview(self.femaleButton)
        self.alertView.addSubview(self.selectionButtonsStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpListSelectionTypeConstraints()
    }
    
    private func setUpActivityLevelAlertType() {
        self.setDefaultAlertType()
        self.selectionButtonsStackView.addArrangedSubview(self.lowActivivtyButton)
        self.selectionButtonsStackView.addArrangedSubview(self.midActivivtyButton)
        self.selectionButtonsStackView.addArrangedSubview(self.highActivivtyButton)
        self.alertView.addSubview(self.selectionButtonsStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpListSelectionTypeConstraints()
    }
    
    private func setUpAproachAlertType() {
        self.setDefaultAlertType()
        self.alertView.addSubview(self.titleLabel)
        self.alertView.addSubview(self.infoBlockStackView)
        self.alertView.addSubview(self.systemButtonsStackView)
        self.setUpAproachAlertTypeConstraints()
    }
    
    private func writeValueInfo() {
        guard let info = self.valueTextField.text,
            let infoDouble = Double(info),
            let tappedInfoViewValue = self.tappedInfoView?.type else { return }
        switch tappedInfoViewValue  {
        case .age:
            //ProfileInfoFileManager.shared.writeAge(to: Int(infoDouble))
         //   UserModel.shared.setAge(to: Int(infoDouble))
            self.profileManager.writeAge(to: Int(infoDouble))
        case .weight:
           // UserModel.shared.setWeight(to: infoDouble)
            self.profileManager.writeWeight(to: infoDouble)
        case .height:
          //  UserModel.shared.setHeight(to: infoDouble)
            self.profileManager.writeHeight(to: infoDouble)
        default:
            break
        }
    }
    
    private func writeListSelectionInfo() {
        for view in self.selectionButtonsStackView.arrangedSubviews {
            guard let button = view as? UIButton else { return }
            if button.isSelected {
                guard let buttonTittle = button.titleLabel?.text,
                    let tappedInfoViewValue = self.tappedInfoView?.type else { return }
                switch tappedInfoViewValue {
                case .gender:
                    
                    guard let newGenderValue = ProfileInfoModel.Gender.init(rawValue: buttonTittle) else { return }
                    self.profileManager.writeGender(to: newGenderValue)
                    //guard let setedGender = UserModel.Gender.init(rawValue: buttonTittle) else { return }
                    //UserModel.shared.setGender(to: setedGender )
                case .activityLevel:
                    guard let newActivityLevelValue = ProfileInfoModel.ActivityLevel.init(rawValue: buttonTittle) else { return }
                    self.profileManager.writeActivityLevel(to: newActivityLevelValue )
//                    guard let setedActivityLevel = UserModel.ActivivtyLevel.init(rawValue: buttonTittle) else { return }
//                    UserModel.shared.setActivivtyLevel(to: setedActivityLevel)
                default:
                    break
                }
            }
        }
    }
    
    private func writeNewAproachInfo() {
        guard let reps = Int(self.repsTextField.text ?? "0") else { return }
        guard let weight = Double(self.weightTextField.text ?? "0") else { return }
        self.exercice?.addAproachWith(reps, and: weight)
    }
    
    private func changeAproachInfo(for index: Int) {
        guard let reps = Int(self.repsTextField.text ?? "0") else { return }
        guard let weight = Double(self.weightTextField.text ?? "0") else { return }
        self.exercice?.changeAproach(index, with: reps, and: weight)
    }
      
    private func setButtonState(_ button: UIButton) {
        button.layer.backgroundColor = button.isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
    
    private func setUpKeyBoardStyle(for textField: UITextField) {
        textField.keyboardType = .decimalPad
    }
    
    private func showKeyboard(for textField: UITextField) {
       textField.becomeFirstResponder()
    }
    
    private func hideKeyboard(for textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    private func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)
    }
    
    private func cleanViews() {
        self.alertView.subviews.forEach({ $0.removeFromSuperview() })
        self.selectionButtonsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    private func hideKeyboard() {
        self.valueTextField.resignFirstResponder()
        self.weightTextField.resignFirstResponder()
        self.repsTextField.resignFirstResponder()
    }
    
    private func resetTextFields() {
        self.valueTextField.text = nil
        self.weightTextField.text = nil
        self.repsTextField.text = nil
    }
    
    //MARK: - Constraints
    private func setUpDefaultsConstraints() {
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
        
        NSLayoutConstraint.activate([
            self.containerAlertView.topAnchor.constraint(equalTo: self.topAnchor, constant: 64),
            self.containerAlertView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64),
            self.containerAlertView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -64),
            self.containerAlertView.heightAnchor.constraint(equalTo: self.alertView.widthAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            self.alertView.topAnchor.constraint(equalTo: self.containerAlertView.topAnchor, constant: 0),
            self.alertView.leftAnchor.constraint(equalTo: self.containerAlertView.leftAnchor, constant: 0),
            self.alertView.rightAnchor.constraint(equalTo: self.containerAlertView.rightAnchor, constant: 0),
            self.alertView.bottomAnchor.constraint(equalTo: self.containerAlertView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setUpValueAlertTypeConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: -8),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.valueTextField.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.valueTextField.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
            self.valueTextField.centerYAnchor.constraint(equalTo: self.alertView.centerYAnchor),
            self.valueTextField.widthAnchor.constraint(equalTo: self.alertView.widthAnchor, multiplier: 0.5),
            self.valueTextField.heightAnchor.constraint(equalTo: self.alertView.heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.topAnchor.constraint(greaterThanOrEqualTo: self.valueTextField.bottomAnchor,
                                                             constant: 8),
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: 16),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: -16),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setUpListSelectionTypeConstraints() {
        let heightMultiplier: CGFloat =  CGFloat(self.selectionButtonsStackView.arrangedSubviews.count + 1)
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: 16),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: -16),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor, constant: 0),
            self.systemButtonsStackView.heightAnchor.constraint(equalTo: self.alertView.heightAnchor,
                                                         multiplier: 1 / heightMultiplier)
        ])
        
        NSLayoutConstraint.activate([
            self.selectionButtonsStackView.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: -1),
            self.selectionButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: -1),
            self.selectionButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: 1),
            self.selectionButtonsStackView.bottomAnchor.constraint(equalTo: self.systemButtonsStackView.topAnchor)
        ])
    }
    
    private func setUpAproachAlertTypeConstraints() {
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.infoBlockStackView.centerYAnchor.constraint(equalTo: self.alertView.centerYAnchor),
            self.infoBlockStackView.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
            self.infoBlockStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.infoBlockStackView.bottomAnchor.constraint(equalTo: self.systemButtonsStackView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.systemButtonsStackView.leftAnchor.constraint(equalTo: self.alertView.leftAnchor, constant: 8),
            self.systemButtonsStackView.rightAnchor.constraint(equalTo: self.alertView.rightAnchor, constant: -8),
            self.systemButtonsStackView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor, constant: -8),
            self.systemButtonsStackView.heightAnchor.constraint(equalTo: self.alertView.heightAnchor, multiplier: 0.25)
        ])
    }
    
    //MARK: - Actions
    @objc private func selectListButtonPressed(_ button: UIButton) {
        for view in self.selectionButtonsStackView.arrangedSubviews {
            guard let pickedButton = view as? UIButton else { return }
            pickedButton.isSelected = pickedButton != button ? false : true
            self.setButtonState(pickedButton)
        }
    }
    
    @objc private func okPressed() {
        guard let alertType = self.alertType else { return }
        switch alertType {
        case .setValue:
            guard let tappedInfoView = self.tappedInfoView else { return }
            switch tappedInfoView.type {
            case .gender:
                self.writeListSelectionInfo()
                self.tappedInfoView?.valueLabel.text = profileManager.profileInfo?.gender?.rawValue ?? "_"
               // self.tappedInfoView?.valueLabel.text = UserModel.shared.displayGender
            case .activityLevel:
                self.writeListSelectionInfo()
                self.tappedInfoView?.valueLabel.text = profileManager.profileInfo?.activityLevel?.rawValue ?? "_"
               // self.tappedInfoView?.valueLabel.text = UserModel.shared.displayActivityLevel
            case .age:
                self.writeValueInfo()
                self.tappedInfoView?.valueLabel.text = String(profileManager.profileInfo?.age ?? 0)
            case .height:
                self.writeValueInfo()
                self.tappedInfoView?.valueLabel.text = String(profileManager.profileInfo?.height ?? 0)
                //self.tappedInfoView?.valueLabel.text = UserModel.shared.displayHeight
            case .weight:
                self.writeValueInfo()
                self.tappedInfoView?.valueLabel.text = String(profileManager.profileInfo?.weight ?? 0)
               // self.tappedInfoView?.valueLabel.text = UserModel.shared.displayWeight
            default:
                break
            }
        case .newAproachAlert:
            self.writeNewAproachInfo()
        case .aproachAlert:
            guard let changinAproach = self.changingAproachIndex else { return }
            self.changeAproachInfo(for: changinAproach)
        }
        self.hideAlert()
        guard let alertOkPressed = self.delegate?.alertOkPressed?() else { return }
        alertOkPressed
    }
    
    @objc private func cancelPressed() {
        self.hideAlert()
        guard let alertCancelTapped = self.delegate?.alertCancelPressed?() else { return }
        alertCancelTapped
    }
}



